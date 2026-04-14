module top_module(itr, clk, ct
,       x0, y0
,       x1, y1
);parameter width = 32;

    input [4:0] ct;
    input clk;
    input [0:0] itr;
    input [width-1:0] x0;
    output [width-1:0] y0;
    reg  [width-1:0] y0;
    input [width-1:0] x1;
    output [width-1:0] y1;
    reg  [width-1:0] y1;
    wire [width-1:0] t0_0, t0_1;
    reg [width-1:0] t1_0, t1_1;

    reg [0:0] control;

    always @(posedge clk) begin
      case(ct)
        5'd0: control <= 1'b1;
        5'd1: control <= 1'b1;
        5'd2: control <= 1'b1;
        5'd3: control <= 1'b1;
        5'd4: control <= 1'b1;
        5'd5: control <= 1'b1;
        5'd6: control <= 1'b1;
        5'd7: control <= 1'b1;
        5'd8: control <= 1'b1;
        5'd9: control <= 1'b1;
        5'd10: control <= 1'b1;
        5'd11: control <= 1'b1;
        5'd12: control <= 1'b1;
        5'd13: control <= 1'b1;
        5'd14: control <= 1'b1;
        5'd15: control <= 1'b1;
        5'd16: control <= 1'b0;
        5'd17: control <= 1'b0;
        5'd18: control <= 1'b0;
        5'd19: control <= 1'b0;
        5'd20: control <= 1'b0;
        5'd21: control <= 1'b0;
        5'd22: control <= 1'b0;
        5'd23: control <= 1'b0;
        5'd24: control <= 1'b0;
        5'd25: control <= 1'b0;
        5'd26: control <= 1'b0;
        5'd27: control <= 1'b0;
        5'd28: control <= 1'b0;
        5'd29: control <= 1'b0;
        5'd30: control <= 1'b0;
        5'd31: control <= 1'b0;
      endcase
   end


   reg [0:0] control0;
    always @(posedge clk) begin
       control0 <= control;
    end
    assign t0_0 = x0;
    assign t0_1 = x1;
   always @(posedge clk) begin
         t1_0 <= (control0[0] == 0) ? t0_0 : t0_1;
         t1_1 <= (control0[0] == 0) ? t0_1 : t0_0;
   end
    always @(posedge clk) begin
        y0 <= t1_0;
        y1 <= t1_1;
    end
endmodule