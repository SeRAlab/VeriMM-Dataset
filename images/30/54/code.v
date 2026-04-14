module svm_classifier(
    input wire x1,
    input wire x2,
    output wire y
);
    wire w1 = 1;  // weight for x1
    wire w2 = -1; // weight for x2
    wire b = 0;   // bias

    // Calculate the decision boundary
    wire decision_boundary;
    assign decision_boundary = (w1 * x1 + w2 * x2 + b) > 0;

    // Output y based on the decision boundary
    assign y = decision_boundary ? 1 : 0;
endmodule