module top_module(datain, dataout);input [15:0] datain; 
    output [31:0] dataout; 
    reg [31:0] dataout;

    

    always @(datain) 
    begin
	dataout={{16{datain[15]}},datain[15:0]}; 
    end

    endmodule