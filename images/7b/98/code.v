module top_module(input CLK, D, output reg Q, output reg QN, input RSTB, SETB, VDD, VSS);always @(posedge CLK) begin
        if (RSTB == 0) begin
            Q <= 0;
            QN <= 1;
        end else if (SETB == 0) begin
            Q <= 1;
            QN <= 0;
        end else begin
            Q <= D;
            QN <= ~D;
        end
    end

endmodule