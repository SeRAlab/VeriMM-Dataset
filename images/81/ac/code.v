module shift_register(
    input           clk,
    input           reset,
    input           load,
    input           shift_ctrl,
    input   [7:0]   data_in,

    output reg [7:0] data_out
);

always @(posedge clk or posedge reset)
begin
    if (reset) begin
        data_out <= 8'b00000000;
    end else if (load) begin
        data_out <= data_in;
    end else begin
        if (shift_ctrl) begin
            data_out <= data_out << 1;
        end else begin
            data_out <= data_out >> 1;
        end
    end
end

endmodule