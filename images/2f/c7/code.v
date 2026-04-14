module portfolio_optimization(  
    input [7:0] weight1,  
    input [7:0] return1,  
    input [7:0] weight2,  
    input [7:0] return2,  
    input [7:0] weight3,  
    input [7:0] return3,  
    input [7:0] weight4,  
    input [7:0] return4,  
    input [7:0] weight5,  
    input [7:0] return5,  
    output [15:0] total_weighted_return  
);  
    wire [15:0] weighted_return1;  
    wire [15:0] weighted_return2;  
    wire [15:0] weighted_return3;  
    wire [15:0] weighted_return4;  
    wire [15:0] weighted_return5;  

    assign weighted_return1 = weight1 * return1;  
    assign weighted_return2 = weight2 * return2;  
    assign weighted_return3 = weight3 * return3;  
    assign weighted_return4 = weight4 * return4;  
    assign weighted_return5 = weight5 * return5;  

    assign total_weighted_return = weighted_return1 + weighted_return2 +  
                                    weighted_return3 + weighted_return4 +  
                                    weighted_return5;  
endmodule