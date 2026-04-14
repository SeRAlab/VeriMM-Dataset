module top_module(
    input clock,
    input reset_n,
    input [31:0] data_in,
    input write_en,
    input [4:0] address,
    output reg [31:0] data_out
);reg [31:0] mem [31:0];

always @(posedge clock) begin
    if (!reset_n) begin
        data_out <= 0;
    end else begin
        if (write_en) begin
            mem[address] <= data_in;
        end else begin
            data_out <= mem[address];
        end
    end
end

endmodule