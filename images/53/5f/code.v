module shift_register_8bit (
    input clk,
    input load,
    input [7:0] data_in,
    output reg [7:0] data_out
);

always @(posedge clk) begin
    if (load) begin
        data_out <= data_in;
    end else begin
        data_out <= data_out << 1;
    end
end

endmodule