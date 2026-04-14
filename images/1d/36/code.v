module decision_tree(
    input [2:0] x,
    output reg [1:0] y
);

always @(*) begin
    if (x[2]) begin
        if (x[1]) 
            y = 2'b00; // Class 0
        else 
            y = 2'b01; // Class 1
    end else begin
        if (x[0]) 
            y = 2'b10; // Class 2
        else 
            y = 2'b11; // Class 3
    end
end

endmodule