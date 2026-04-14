module top_module(nrst, clk, en, step, load, cin, cnt);parameter width = 8;

    input nrst;
    input clk;
    input en;
    input [width-1:0] step;
    input load;
    input [width-1:0] cin;
    output reg [width-1:0] cnt;
    
    always @(posedge clk or negedge nrst) begin
        if (~nrst) begin
            cnt <= 0;
        end else if (load) begin
            cnt <= cin;
        end else if (en) begin
            cnt <= cnt + step;
        end
    end
endmodule