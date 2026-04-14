module top_module(
    input           clk,
    input           resetn,

    input [4 :0]    rs,
    input [4 :0]    rt,

    input           wen,    
    input [4 :0]    wreg,   
    input [31:0]    inData, 

    output[31:0]    outA,
    output[31:0]    outB
);reg [31:0] GPR[31:0];

always @(posedge clk) begin
    if(!resetn) begin
        
    end
    else if(wen) begin
        GPR[wreg] = inData;
    end
end

assign outA = GPR[rs];
assign outB = GPR[rt];

endmodule