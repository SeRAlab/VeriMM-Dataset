module register_4bit(
    input clk,
    input reset,
    input load,
    input [3:0] data_in,

    output reg [3:0] data_out
);

// Register logic
always @(posedge clk)
begin
    if (reset)
        data_out <= 4'b0000;
    else if (load)
        data_out <= data_in;
end

endmodule