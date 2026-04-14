module binary_up_counter_4bit (
    input clk,
    input reset,
    input load,
    input [3:0] preset_value,
    output reg [3:0] q);

always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else if (load)
        q <= preset_value;
    else
        q <= q + 1;
    end
    
endmodule