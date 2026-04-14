module top_module(
    input [4:0] RegLe1,
    input [4:0] RegLe2,
    input [4:0] RegEscr,
    input EscrReg,
    input clk,
    input [31:0] datain,
    output wire [31:0] data1,
    output wire [31:0] data2,
    input reset
    );reg [31:0] register [31:0];
wire [31:0] aux;
assign  data1 = register[RegLe1];
assign  data2 = register[RegLe2];

always @(posedge clk )
    begin 
        if(reset==1)
        begin
		
		
        register[0] = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        register[1] = 32'b0000_0000_0000_0000_0000_0000_0000_0100;
        register[2] = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        register[3] = 32'b0000_0000_0000_0000_0000_0000_0000_1001;
        register[4] = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        register[5] = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        register[6] = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        register[7] = 32'b0000_0000_0000_0000_0000_0000_0000_0001;     
        end
    else
        register[0] = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
               

   
    register[RegEscr] = aux;    

    end
    
 
assign aux = (EscrReg==1) ? datain : register[RegEscr];

endmodule