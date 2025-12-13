package main

import (
	"bytes"
	"context"
	"html/template"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

// Lambdaのエントリーポイント
func handler(ctx context.Context, req events.APIGatewayV2HTTPRequest) (events.APIGatewayV2HTTPResponse, error) {

	tmpl, err := template.ParseFiles("templates/index.html")
	if err != nil {
		return events.APIGatewayV2HTTPResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       err.Error(),
		}, nil
	}

	// HTMLを文字列として生成
	var body string
	{
		buf := new(bytes.Buffer)
		if err := tmpl.Execute(buf, nil); err != nil {
			return events.APIGatewayV2HTTPResponse{
				StatusCode: http.StatusInternalServerError,
				Body:       err.Error(),
			}, nil
		}
		body = buf.String()
	}

	return events.APIGatewayV2HTTPResponse{
		StatusCode: http.StatusOK,
		Headers: map[string]string{
			"Content-Type": "text/html; charset=utf-8",
		},
		Body: body,
	}, nil
}

func main() {
	lambda.Start(handler)
}
