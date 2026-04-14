module ofdm_modulator (
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    output reg serial_out
);
    reg [3:0] prev_data;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            prev_data <= 4'b0000;
            serial_out <= 1'b0;
        end else begin
            serial_out <= data_in[0]; // Output the LSB of input data
            prev_data <= data_in; // Store the current data
        end
    end
endmodule