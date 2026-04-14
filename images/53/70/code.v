module top_module(busSLL, busA, sel, zSLL, oSLL, cSLL, nSLL);output [31:0] busSLL;
	input  [31:0] busA, sel;
    output zSLL, nSLL;
    output reg oSLL, cSLL;

    assign busSLL = busA << sel[2:0];

    assign zSLL = ~|busSLL[31:0];
    assign nSLL = busSLL[31];
    always @(*) begin
    	if (sel[2:0] == 3'b0) begin
    		cSLL = 1'b0;
    		oSLL = 1'b0;
    	end else if (sel[2:0] == 3'b1) begin
    		cSLL = busSLL[31];
    		oSLL = busSLL[31];
    	end else if (sel[2:0] == 3'b10) begin
    		cSLL = busSLL[30];
            oSLL = |busSLL[31:30];
        end else if (sel[2:0] == 3'b11) begin
            cSLL = busSLL[29];
            oSLL = |busSLL[31:29];
        end else if (sel[2:0] == 3'b100) begin
            cSLL = busSLL[28];
            oSLL = |busSLL[31:28];
        end else if (sel[2:0] == 3'b101) begin
            cSLL = busSLL[27];
            oSLL = |busSLL[31:27];
        end else if (sel[2:0] == 3'b110) begin
            cSLL = busSLL[26];
            oSLL = |busSLL[31:26];
    	end	else begin
    		cSLL = busSLL[25];
    		oSLL = |busSLL[31:25];
    	end
    end
endmodule