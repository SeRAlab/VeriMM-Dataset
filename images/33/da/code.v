module ofdm_modulator (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output reg [63:0] modulated_out
);
    reg [7:0] buffer [0:7]; // Buffer for 8 symbols
    reg [2:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            modulated_out <= 0;
        end else if (count < 8) begin
            buffer[count] <= data_in; // Store incoming data
            count <= count + 1;
        end else if (count == 8) begin
            // Perform IFFT (simulated as a simple concatenation for this example)
            modulated_out <= {buffer[0], buffer[1], buffer[2], buffer[3], buffer[4], buffer[5], buffer[6], buffer[7]};
            count <= 0; // Reset count after processing
        end
    end
endmodule