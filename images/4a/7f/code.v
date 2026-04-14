module top_module(
    input clk,
    input rst_n,
    input [2:0] sel, 
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [3:0] mux_out,
    output reg [11:0] final_out
);reg [5:0] johnson_counter;
reg [3:0] mux_sel;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        johnson_counter <= 6'b000000;
        mux_sel <= 4'b0000;
        mux_out <= 4'b0000;
        final_out <= 12'b000000000000;
    end else begin
        johnson_counter <= {johnson_counter[3:0], johnson_counter[5]};
        case (johnson_counter)
            6'b000000: mux_sel <= 4'b0000;
            6'b100000: mux_sel <= 4'b0001;
            6'b110000: mux_sel <= 4'b0010;
            6'b111000: mux_sel <= 4'b0011;
            6'b111100: mux_sel <= 4'b0100;
            6'b111110: mux_sel <= 4'b0101;
            6'b111111: mux_sel <= 4'b0110;
            6'b011111: mux_sel <= 4'b0111;
            6'b001111: mux_sel <= 4'b1000;
            6'b000111: mux_sel <= 4'b1001;
            6'b000011: mux_sel <= 4'b1010;
            6'b000001: mux_sel <= 4'b1011;
            6'b000000: mux_sel <= 4'b1100;
        endcase
        case (sel)
            3'b000: mux_out <= data0;
            3'b001: mux_out <= data1;
            3'b010: mux_out <= data2;
            3'b011: mux_out <= data3;
            3'b100: mux_out <= data4;
            3'b101: mux_out <= data5;
            default: mux_out <= 4'b0000;
        endcase
        if (sel == 3'b111) begin
            final_out <= {mux_out, johnson_counter};
        end else begin
            final_out <= {4'b0000, johnson_counter};
        end
    end
end

endmodule