module counter2bit(
    input clk,
    input reset,
    input enable,
    
    output reg [1:0] count
);

always @(posedge clk) begin
    if (reset)
        count <= 0;
    else if (enable)
        count <= count + 1;
end

endmodule