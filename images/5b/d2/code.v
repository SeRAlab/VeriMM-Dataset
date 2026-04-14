module top_module(
    input wire clk,
    input wire reset,
    output reg [7:0] out_hi,
    output reg [7:0] out_lo,
    output reg [15:0] final_out
);reg [15:0] input_num;
reg [7:0] upper_byte;
reg [7:0] lower_byte;
reg [1:0] counter;

always @(posedge clk) begin
    if (reset) begin
        counter <= 2'b00;
        input_num <= 16'b0;
    end else begin
        input_num <= $random;
        upper_byte <= input_num[15:8];
        lower_byte <= input_num[7:0];
        case(counter)
            2'b00: final_out <= {upper_byte, lower_byte};
            2'b01: final_out <= {lower_byte, upper_byte};
            2'b10: final_out <= {upper_byte, upper_byte};
            2'b11: final_out <= {lower_byte, lower_byte};
        endcase
        counter <= counter + 1;
    end
end

assign out_hi = upper_byte;
assign out_lo = lower_byte;

endmodule