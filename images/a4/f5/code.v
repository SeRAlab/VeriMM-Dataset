module top_module(
    input clk,
    input C11,  
    input C3,   
    input C17, 
    input C18, 
    input [15:0] ACC_output,
    input [15:0] MR_output,
    input [15:0] DR_output,
    input [15:0] RAM_output,
    output reg [15:0] MBR_output
    );always @(posedge clk)
    begin
        if(C11)
            MBR_output <= ACC_output;
        else if(C17)
            MBR_output <= MR_output;
        else if(C18)
            MBR_output <= DR_output;
        else if(C3)
            MBR_output <= RAM_output;
    end
    
endmodule