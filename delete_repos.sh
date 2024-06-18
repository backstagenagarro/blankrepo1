name: Delete Organization Repositories

on:
  push:
    branches:
      - main  # Run the workflow on pushes to the main branch

jobs:
  delete_org_repos:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up jq
        run: |
          sudo apt-get update
          sudo apt-get install -y jq

      - name: Set environment variables
        run: |
          echo "MY_USERNAME=${{ secrets.MY_USERNAME }}" >> $GITHUB_ENV
          echo "MY_TOKEN=${{ secrets.MY_TOKEN }}" >> $GITHUB_ENV
          echo "MY_ORG=${{ secrets.MY_ORG }}" >> $GITHUB_ENV

      - name: Run delete_org_repos.sh
        run: bash delete_org_repos.sh
