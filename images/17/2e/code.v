module svm_classifier (
    input [7:0] x,      // x-coordinate of the data point
    input [7:0] y,      // y-coordinate of the data point
    output reg class     // output class (0 or 1)
);
    always @(*) begin
        if (y > x + 100)
            class = 1;   // class 1 if above the line
        else
            class = 0;   // class 0 otherwise
    end
endmodule