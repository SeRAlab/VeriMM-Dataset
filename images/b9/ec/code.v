module top_module(
    input clk,
    input reset,
    input [2:0] sel,
    input t,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [3:0] out
);// 6-to-1 multiplexer
    reg [3:0] mux_out;
    always @(*) begin
        case(sel)
            3'b000: mux_out = data0;
            3'b001: mux_out = data1;
            3'b010: mux_out = data2;
            3'b011: mux_out = data3;
            3'b100: mux_out = data4;
            3'b101: mux_out = data5;
            default: mux_out = 4'b0000;
        endcase
    end

    // T flip-flop
    reg t_ff;
    always @(posedge clk, negedge reset) begin
        if(!reset) begin
            t_ff <= 1'b0;
        end else begin
            if(t) begin
                t_ff <= ~t_ff;
            end
        end
    end

    // Functional module
    always @(*) begin
        if(t_ff) begin
            out = mux_out;
        end else begin
            out = 4'b0000;
        end
    end

endmodule