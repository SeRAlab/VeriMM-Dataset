module top_module(
    input wire clk,
    input wire reset_n,
    input wire [3:0] bin_input,
    output wire [7:0] hex_output
);reg [3:0] counter;
reg [7:0] hex_value;

always @(posedge clk, negedge reset_n) begin
    if (!reset_n) begin
        counter <= 0;
        hex_value <= 8'b00000000;
    end else begin
        case (bin_input)
            4'b0000: hex_value <= 8'b01111111; // 0
            4'b0001: hex_value <= 8'b00000110; // 1
            4'b0010: hex_value <= 8'b10110110; // 2
            4'b0011: hex_value <= 8'b10011110; // 3
            4'b0100: hex_value <= 8'b11001100; // 4
            4'b0101: hex_value <= 8'b11011010; // 5
            4'b0110: hex_value <= 8'b11111010; // 6
            4'b0111: hex_value <= 8'b00001110; // 7
            4'b1000: hex_value <= 8'b11111110; // 8
            4'b1001: hex_value <= 8'b11011110; // 9
            4'b1010: hex_value <= 8'b11101110; // A
            4'b1011: hex_value <= 8'b11111000; // B
            4'b1100: hex_value <= 8'b01110010; // C
            4'b1101: hex_value <= 8'b10111110; // D
            4'b1110: hex_value <= 8'b11110010; // E
            4'b1111: hex_value <= 8'b11100010; // F
            default: hex_value <= 8'b00000000;
        endcase

        counter <= counter + 1;
        if (counter == 4) begin
            counter <= 0;
        end
    end
end

assign hex_output = {hex_value, ~{counter, 2'b00}};

endmodule