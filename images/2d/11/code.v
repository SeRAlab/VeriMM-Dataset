module divide_by_4 (
    input clk,
    input [1:0] in,
    output reg out
);

always @(posedge clk) begin
    if (in == 2'b00) 
        out <= 1'b1; // Output high for 0
    else if (in == 2'b01) 
        out <= 1'b0; // Output low for 1
    else if (in == 2'b10) 
        out <= 1'b0; // Output low for 2
    else if (in == 2'b11) 
        out <= 1'b0; // Output low for 3
end

endmodule