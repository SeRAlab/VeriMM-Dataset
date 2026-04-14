module ofdm_modulator (
    input clk,           // Clock input
    input rst,           // Reset signal
    input [3:0] data_in, // 4-bit input data
    output reg [15:0] modulated_out // 16-bit modulated output
);

    reg [3:0] subcarrier_data [0:3]; // Array for storing data for 4 subcarriers
    reg [1:0] count; // Counter for subcarriers

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            modulated_out <= 16'b0; // Reset output
            count <= 2'b0; // Reset counter
        end else begin
            subcarrier_data[count] <= data_in; // Store data in subcarrier
            count <= count + 1; // Increment counter
            if (count == 2'b11) begin // If we have filled all subcarriers
                modulated_out <= {subcarrier_data[3], subcarrier_data[2], subcarrier_data[1], subcarrier_data[0]}; // Concatenate to output
            end
        end
    end
endmodule