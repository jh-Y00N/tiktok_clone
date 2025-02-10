import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

admin.initializeApp();

export const onVideoCreated = functions.firestore.onDocumentCreated("/videos/{videoId}", async (event) => {
    const snapshot = event.data;
    if (snapshot == null) return;
    const spawn = require('child-process-promise').spawn;
    const video = snapshot.data();
    await spawn("ffmpeg", [
        "-i",   // input
        video.fileUrl,  // take the video that users uploaded
        "-ss",  // move to
        "00:00:01.000", // 1s
        "-vframes", // take
        "1", // one frame
        "-vf",  // add video filter
        "scale=150:-1",  // width = 150, height will be set according to aspect ratio
        `/tmp/${snapshot.id}.jpg`  // save the generated file to the temporary storage that will be deleted
    ]);

    const storage = admin.storage();
    const [file, _] = await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
        destination: `thumbnails/${snapshot.id}.jpg`
    });
    await file.makePublic();
    await snapshot.ref.update({ "thumbnailUrl": file.publicUrl() });

    const db = admin.firestore();
    await db.collection("users").doc(video.creatorUid).collection("videos").doc(snapshot.id).set({
        "thumbnailUrl": file.publicUrl(),
        "videoId": snapshot.id
    });
});

export const onLikeCreated = functions.firestore.onDocumentCreated("likes/{likeId}", async (event) => {
    const snapshot = event.data;
    const db = admin.firestore();
    if (snapshot == null) return;

    const [videoId, userId] = snapshot.id.split("-000-");
    await db.collection("videos").doc(videoId).update({ "likes": admin.firestore.FieldValue.increment(1) });
    await db.collection("users").doc(userId).collection("likedVideos").doc(videoId).set({ "videoId": videoId });
    console.log(`Liked video added for userId: ${userId}, videoId: ${videoId}`);
});

export const onLikeRemoved = functions.firestore.onDocumentDeleted("likes/{likeId}", async (event) => {
    const snapshot = event.data;
    const db = admin.firestore();
    if (snapshot == null) return;

    const [videoId, userId] = snapshot.id.split("-000-");
    await db.collection("videos").doc(videoId).update({ "likes": admin.firestore.FieldValue.increment(-1) });
    await db.collection("users").doc(userId).collection("likedVideos").doc(videoId).delete();
});