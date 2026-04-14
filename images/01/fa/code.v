module DAC (
    input [15:0] data_in,
    output reg [15:0] data_out
);

parameter THRESHOLD = 16'd32768;
parameter MAX_VALUE = 16'd65535;

always @(*) begin
    if (data_in > THRESHOLD) begin
        data_out = MAX_VALUE;
    end else begin
        data_out = data_in;
    end
end

endmodule