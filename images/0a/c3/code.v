module ofdm_modulator(
    input clk,
    input reset,
    input [3:0] data_in,
    output reg [3:0] data_out
);
    reg [2:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b000;
            data_out <= 4'b0000;
        end else if (count < 3'b100) begin
            count <= count + 1;
            data_out <= data_in; // Store the input data
        end
    end
endmodule