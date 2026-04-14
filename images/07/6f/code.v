module counter_64bit (
    input clk,
    input reset,
    output reg [63:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) 
        count <= 64'b0;
    else 
        count <= count + 1;
end

endmodule