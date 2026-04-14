module branch_predictor (  
    input clk,  
    input branch_out,  
    output reg [1:0] prediction  
);  
    reg [1:0] state;  

    always @(posedge clk) begin  
        case (state)  
            2'b00: state <= (branch_out) ? 2'b01 : 2'b00;  
            2'b01: state <= (branch_out) ? 2'b10 : 2'b00;  
            2'b10: state <= (branch_out) ? 2'b11 : 2'b01;  
            2'b11: state <= (branch_out) ? 2'b11 : 2'b10;  
        endcase  
    end  

    always @(*) begin  
        prediction = state;  
    end  
endmodule