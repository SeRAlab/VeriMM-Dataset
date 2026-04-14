module ShiftRegister (
    input clk,
    input reset,
    input load,
    input [3:0] data_in,
    output reg [3:0] data_out
);

always @(posedge clk) begin
    if (reset) begin
        data_out <= 4'd0;
    end else if (load) begin
        data_out <= data_in;
    end else begin
        data_out <= data_out << 1;
    end
end

endmodule