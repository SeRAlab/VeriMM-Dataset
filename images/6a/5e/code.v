module top_module(
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    input [1:0] add_in,
    input clk,
    input reset,
    input select,
    output reg [7:0] out
);reg [3:0] mux_out;
reg [1:0] add_out;

always @ (sel or data0 or data1 or data2 or data3 or data4 or data5) begin
    case (sel)
        3'b000: mux_out = data0;
        3'b001: mux_out = data1;
        3'b010: mux_out = data2;
        3'b011: mux_out = data3;
        3'b100: mux_out = data4;
        3'b101: mux_out = data5;
        default: mux_out = 4'b0;
    endcase
end

always @ (add_in or select) begin
    if (select == 1'b0) begin
        add_out = 2'b0;
    end else begin
        add_out = add_in;
    end
end

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0;
    end else begin
        if (select == 1'b0) begin
            out <= mux_out;
        end else begin
            out <= {2'b0, mux_out} + {2'b0, add_out};
        end
    end
end

endmodule