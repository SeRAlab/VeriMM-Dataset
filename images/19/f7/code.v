module decision_tree (
    input wire A,
    input wire B,
    output reg [1:0] category
);
    always @(*) begin
        if (A == 0 && B == 0)
            category = 2'b00; // Category 0
        else if (A == 0 && B == 1)
            category = 2'b01; // Category 1
        else if (A == 1 && B == 0)
            category = 2'b10; // Category 2
        else
            category = 2'b11; // Category 3 (A = 1, B = 1)
    end
endmodule