module decision_tree_inference (
    input [2:0] feature,
    output reg [1:0] class
);
    
always @(*) begin
    if (feature < 3'b100) begin
        class = 2'b00; // Output class '00'
    end else if (feature >= 3'b100 && feature <= 3'b110) begin
        class = 2'b01; // Output class '01'
    end else begin
        class = 2'b10; // Output class '10'
    end
end

endmodule