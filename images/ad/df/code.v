module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    input [1:0] S,
    input [3:0] binary_in,
    input clk,
    output reg [6:0] seven_segment_out,
    output reg EN1,
    output reg EN2,
    output reg EN3
);reg [3:0] priority_input;
reg [3:0] bcd_out;
reg [1:0] digit_counter;
reg [3:0] bcd_counter;

always @(posedge clk) begin
    // Priority encoder
    case ({A, B, C, D})
        4'b1110: priority_input <= A;
        4'b1101: priority_input <= B;
        4'b1011: priority_input <= C;
        4'b0111: priority_input <= D;
        default: priority_input <= 4'b0000;
    endcase
    
    // Binary to BCD converter
    if (digit_counter == 0) begin
        bcd_out <= binary_in % 10;
    end else if (digit_counter == 1) begin
        bcd_out <= (binary_in / 10) % 10;
    end else if (digit_counter == 2) begin
        bcd_out <= (binary_in / 100) % 10;
    end else begin
        bcd_out <= (binary_in / 1000) % 10;
    end
    
    // Output selection
    case (S)
        2'b00: seven_segment_out <= bcd_out;
        2'b01: seven_segment_out <= priority_input;
        2'b10: seven_segment_out <= 7'b1111111;
        2'b11: seven_segment_out <= 7'b0000000;
    endcase
    
    // Digit enable signals
    if (digit_counter == 0) begin
        EN1 <= 1;
        EN2 <= 0;
        EN3 <= 0;
    end else if (digit_counter == 1) begin
        EN1 <= 0;
        EN2 <= 1;
        EN3 <= 0;
    end else if (digit_counter == 2) begin
        EN1 <= 0;
        EN2 <= 0;
        EN3 <= 1;
    end else begin
        EN1 <= 0;
        EN2 <= 0;
        EN3 <= 0;
    end
    
    // Digit counter
    if (digit_counter == 3) begin
        digit_counter <= 0;
    end else begin
        digit_counter <= digit_counter + 1;
    end
end

endmodule