module top_module(
    input clk,               // Added clk input
    input [3:0] data_in,
    input [3:0] en,
    output reg [6:0] seg_a,
    output reg [6:0] seg_b,
    output reg [6:0] seg_c,
    output reg [6:0] seg_d
);reg [3:0] twos_comp;
    reg [6:0] hex_val;
    reg [1:0] digit_sel = 2'b00;
    
    always @(*) begin
        twos_comp = ~data_in + 1;
        case (twos_comp)
            4'b0000: hex_val = 7'b100_0000;
            4'b0001: hex_val = 7'b111_1001;
            4'b0010: hex_val = 7'b010_0100;
            4'b0011: hex_val = 7'b011_0000;
            4'b0100: hex_val = 7'b001_1001;
            4'b0101: hex_val = 7'b001_0010;
            4'b0110: hex_val = 7'b000_0010;
            4'b0111: hex_val = 7'b111_1000;
            4'b1000: hex_val = 7'b000_0000;
            4'b1001: hex_val = 7'b001_1000;
            4'b1010: hex_val = 7'b000_0100;
            4'b1011: hex_val = 7'b000_0001;
            4'b1100: hex_val = 7'b000_0110;
            4'b1101: hex_val = 7'b000_1110;
            4'b1110: hex_val = 7'b000_1100;
            4'b1111: hex_val = 7'b000_0111;
            default: hex_val = 7'b111_1111;
        endcase
    end
    
    always @(posedge clk) begin
        if (en[0]) begin
            digit_sel <= 2'b00;
            seg_a <= hex_val;
        end
        if (en[1]) begin
            digit_sel <= 2'b01;
            seg_b <= hex_val;
        end
        if (en[2]) begin
            digit_sel <= 2'b10;
            seg_c <= hex_val;
        end
        if (en[3]) begin
            digit_sel <= 2'b11;
            seg_d <= hex_val;
        end
    end
    
endmodule