module top_module(input CLK, RSTB, VDD, VSS, output reg [3:0] Q, QN);always @(posedge CLK, negedge RSTB) begin
        if (~RSTB) begin
            Q <= 4'b0;
        end else begin
            Q <= Q + 1;
        end
    end
    
    assign QN = ~Q;
    
endmodule