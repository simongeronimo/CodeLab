package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/v2/mongo"
	"go.mongodb.org/mongo-driver/v2/mongo/options"
)

func main() {
	// 1. Setup connection string
	uri := ""

	// 2. Create a new client and connect to the server
	client, err := mongo.Connect(options.Client().ApplyURI(uri))
	if err != nil {
		log.Fatal(err)
	}

	// 3. Ensure connection is closed when main finishes
	defer func() {
		if err := client.Disconnect(context.TODO()); err != nil {
			log.Fatal(err)
		}
	}()

	// 4. Ping the database to verify the connection
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	err = client.Ping(ctx, nil)
	if err != nil {
		log.Fatalf("Could not connect to MongoDB: %v", err)
	}

	fmt.Println("Successfully connected to MongoDB on TrueNAS!")

	// 5. Access a collection (Make sure these names are correct!)
	coll := client.Database("magic-stream-movies").Collection("genres")

	fmt.Println("Fetching documents...")

	// 6. Execute the Find query (an empty bson.D{} filter matches everything)
	cursor, err := coll.Find(context.TODO(), bson.M{})
	if err != nil {
		log.Fatalf("Error finding documents: %v", err)
	}

	// Ensure the cursor is closed once we are done
	defer cursor.Close(context.TODO())

	// 7. Decode all documents into a slice of generic BSON maps
	var results []bson.M
	if err = cursor.All(context.TODO(), &results); err != nil {
		log.Fatalf("Error decoding documents: %v", err)
	}

	// 8. Print the results
	if len(results) == 0 {
		fmt.Println("The collection is empty!")
	} else {
		for i, doc := range results {
			fmt.Printf("Document %d: %v\n", i+1, doc)
		}
	}
}
