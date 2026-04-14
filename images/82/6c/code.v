module top_module(
    input wire clk,
    input wire rst,
    (* mark_debug = "true" *) input wire start,
    (* mark_debug = "true" *) input wire stop,
    (* mark_debug = "true" *) output reg [31:0] cnt_o
    );reg run;
    
    always @(posedge clk) begin
        if (rst) begin
            cnt_o <= 32'b0;
            run <= 0;
        end else begin
            if (start == 1'b0 && stop == 1'b0) run <= run;
            if (start == 1'b0 && stop == 1'b1) run <= 0;
            if (start == 1'b1 && stop == 1'b0) run <= 1;
            if (start == 1'b1 && stop == 1'b1) run <= 0;
            if (run) cnt_o <= cnt_o + 1;
        end
    end
    
endmodule