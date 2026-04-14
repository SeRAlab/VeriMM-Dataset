module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input [3:0] binary_in, // 4-bit binary input
    output reg [3:0] bcd_out, // 4-bit BCD output
    output reg EN1, // Enable signal for the least significant digit
    output reg EN2, // Enable signal for the middle digit
    output reg EN3, // Enable signal for the most significant digit
    output reg [8:0] sum // Output of the sum of up counter and BCD value
);reg [3:0] up_counter;
reg [3:0] bcd_counter;
reg [1:0] digit_counter;

always @(posedge clk) begin
    if (reset) begin
        up_counter <= 0;
        bcd_counter <= 0;
        digit_counter <= 0;
        EN1 <= 1;
        EN2 <= 0;
        EN3 <= 0;
    end else begin
        up_counter <= up_counter + 1;
        if (digit_counter == 0) begin
            bcd_counter <= binary_in;
            digit_counter <= 1;
            EN1 <= 1;
            EN2 <= 0;
            EN3 <= 0;
        end else if (digit_counter == 1) begin
            bcd_counter <= {1'b0, bcd_counter[3:1]};
            digit_counter <= 2;
            EN1 <= 0;
            EN2 <= 1;
            EN3 <= 0;
        end else begin
            bcd_counter <= {1'b0, bcd_counter[3:1]};
            digit_counter <= 0;
            EN1 <= 0;
            EN2 <= 0;
            EN3 <= 1;
        end
    end
end

always @(posedge clk) begin
    sum <= up_counter + bcd_out;
end

always @(posedge clk) begin
    case (digit_counter)
        0: bcd_out <= bcd_counter[3:0];
        1: bcd_out <= bcd_counter[7:4];
        2: bcd_out <= bcd_counter[11:8];
        default: bcd_out <= 4'b0000;
    endcase
end

endmodule