module top_module(clk, d, rstn, prsn, q, qn);input clk, rstn, prsn;
    input [4:0] d;
    output [4:0] q, qn;
    reg [4:0] q, qn;
    
    always @(posedge clk) begin
        if (!rstn) begin
            q <= 5'b0;
            qn <= 5'b1;
        end else if (!prsn) begin
            q <= 5'b1;
            qn <= 5'b0;
        end else begin
            q <= d;
            qn <= ~d;
        end
    end
endmodule