const admin = require("firebase-admin");
const express = require("express");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore(); // Initialize Firestore
const app = express();
const port = 3000;

// Middleware to parse JSON request bodies
app.use(express.json());

// Endpoint to send notification
app.post("/send-notification", async (req, res) => {
  console.log("HERE!");
  const { userId, title, body } = req.body;
  console.log(req.body);

  try {
    // Query the device_tokens collection for the user's deviceId
    const deviceTokenSnapshot = await db
      .collection("device_tokens")
      .doc(userId)
      .get();

    if (!deviceTokenSnapshot.exists) {
      console.log("EMPTY");
      return res.status(200).send("No user Found.");
    }

    // Assuming only one device per user
    const deviceTokens = deviceTokenSnapshot.data().tokens;
    console.log(deviceTokens);

    // Construct the notification payload

    for (const token of deviceTokens) {
      const message = {
        token,
        notification: {
          title: title,
          body: body,
        },
      };
      // Send the notification using Firebase Cloud Messaging
      await admin.messaging().send(message);
    }

    // Respond to the client
    res.status(200).send("Notification sent successfully.");
  } catch (error) {
    console.error("Error sending notification:", error);
    res.status(500).send("Error sending notification.");
  }
});

// Sample root endpoint
app.get("/", (req, res) => {
  res.send("Hello World!");
});

// Start the server
app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
