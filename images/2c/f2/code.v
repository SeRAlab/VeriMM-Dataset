module sipo_shift_register (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg [4:0] parallel_out,
    output reg valid
);

    reg [2:0] count; // 3 bits to count up to 5

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            parallel_out <= 5'b00000;
            valid <= 1'b0;
            count <= 3'b000;
        end else if (count < 3'd5) begin
            parallel_out <= {parallel_out[3:0], serial_in}; // Shift in the new bit
            count <= count + 1;
            if (count == 3'd4) begin
                valid <= 1'b1; // Signal valid output after 5 bits received
            end
        end
    end

endmodule