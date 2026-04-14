module top_module(
    input wire status,
    input wire reset,
    input wire clk,  
    input wire [31:0] d_en, 
    output wire [31:0] data    
);reg [31:0]d_sal; 

always @(posedge clk or posedge reset )
    if (reset==1'b1)
           d_sal=0;
    else
    d_sal <= d_en;

assign data=d_sal;
endmodule