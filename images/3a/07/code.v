module deserializer (
    input wire clk,
    input wire reset,
    input wire [7:0] din,
    output reg [31:0] dout,
    output reg valid
);
    reg [2:0] counter;
    reg [31:0] data_buffer;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            dout <= 0;
            valid <= 0;
            data_buffer <= 0;
        end else begin
            data_buffer <= {data_buffer[23:0], din}; // Shift in new 8 bits
            counter <= counter + 1;

            if (counter == 3'd3) begin
                dout <= data_buffer; // Output the 32-bit data
                valid <= 1; // Indicate output is valid
                counter <= 0; // Reset counter for the next data
            end else begin
                valid <= 0; // Output not valid until four inputs
            end
        end
    end
endmodule