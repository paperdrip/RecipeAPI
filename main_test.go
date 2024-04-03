package main

import (
	"RecipesAPI/pkg/recipes"
	"bytes"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"
)

func readTestData(t *testing.T, name string) []byte {
	t.Helper()
	content, err := os.ReadFile("../../testdata/" + name)
	if err != nil {
		t.Errorf("Cound not read %v", name)
	}
	return content
}

func TestRecipesHandlerCRUD_Integration(t *testing.T) {

	// Create a MemStore and Recipe Handler
	store := recipes.NewMemStore()
	recipesHandler := NewRecipesHandler(store)

	// Test Data
	hamAndCheese := readTestData(t, "ham_and_cheese_recipe.json")
	hamAndCheeseReader := bytes.NewReader(hamAndCheese)

	// CREATE - add a new recipe
	req := httptest.NewRequest(http.MethodPost, "/recipes", hamAndCheeseReader)
	w := httptest.NewRecorder()
	recipesHandler.ServerHTTP(w, req)

}
