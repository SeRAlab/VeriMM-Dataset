module shift_register_4bit(
    input wire clk,
    input wire load,
    input wire [3:0] data_in,
    output reg [3:0] data_out
    );

always @(posedge clk) begin
    if (load)
        data_out <= data_in;
    else
        data_out <= {1'b0, data_out[3:1]};
end

endmodule