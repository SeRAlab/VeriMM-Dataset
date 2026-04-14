module top_module(
    input clk, rst,
    input RegWrite, 
    input [4:0] r1, r2, w, 
    input [31:0] wdata, 
    output [31:0] rdata1, rdata2
);reg [31:0] Reg[31:1]; 
    integer i;
    
    assign rdata1 = (r1==5'b0) ? 32'b0 : Reg[r1]; 
    assign rdata2 = (r2==5'b0) ? 32'b0 : Reg[r2];

    always @ (posedge clk or posedge rst) begin
        if (rst)                               
            for(i=1;i<32;i=i+1) Reg[i]<=32'b0;  
        else if ( RegWrite && ~(w==5'b0) )      
                Reg[w] <= wdata;
    end
endmodule