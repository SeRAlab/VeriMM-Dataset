module top_module(
    input clk,
    input reset,
    input [7:0] in,
    output reg [3:0] out,
    output reg [2:0] select,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5
);reg [1:0] state;
reg [7:0] prev_in;
reg [3:0] mux_select;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        prev_in <= 8'b0;
        mux_select <= 4'b0000;
        select <= 3'b111;
        out <= 4'b0000;
    end else begin
        case (state)
            2'b00: begin
                prev_in <= in;
                state <= 2'b01;
            end
            2'b01: begin
                if (in > prev_in) begin
                    state <= 2'b10;
                    mux_select <= mux_select + 1;
                end else if (in < prev_in) begin
                    state <= 2'b10;
                    mux_select <= mux_select + 1;
                end else begin
                    state <= 2'b00;
                end
                prev_in <= in;
            end
            2'b10: begin
                if (mux_select > 5) begin
                    state <= 2'b00;
                    mux_select <= 4'b0000;
                    select <= 3'b111;
                    out <= 4'b0000;
                end else begin
                    select <= mux_select;
                    case (mux_select)
                        4'b0000: out <= data0;
                        4'b0001: out <= data1;
                        4'b0010: out <= data2;
                        4'b0011: out <= data3;
                        4'b0100: out <= data4;
                        4'b0101: out <= data5;
                        default: out <= 4'b0001;
                    endcase
                    state <= 2'b00;
                end
            end
        endcase
    end
end

endmodule