module shift_register (
    input clk,
    input load,
    input shift_enable,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    always @(posedge clk) begin
        if (load) begin
            data_out <= data_in; // Load new data when load signal is high
        end else if (shift_enable) begin
            data_out <= {data_out[6:0], 1'b0}; // Shift left and fill LSB with zero
        end
    end
endmodule