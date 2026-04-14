module binary_counter(
    input wire clk,
    input wire enable,
    input wire reset,
    output reg [3:0] count
    );

always @(posedge clk or posedge reset) begin
    if (reset) 
        count <= 4'b0000;
    else if (enable)
        count <= count + 1;
end

endmodule