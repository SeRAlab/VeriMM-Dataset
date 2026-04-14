module DWT_4Sample (  
    input clk,  
    input reset,  
    input [15:0] x0,  
    input [15:0] x1,  
    input [15:0] x2,  
    input [15:0] x3,  
    output reg [15:0] approx,  
    output reg [15:0] detail  
);  
    reg [15:0] temp_approx;  
    reg [15:0] temp_detail;  
    reg [1:0] state;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            approx <= 16'b0;  
            detail <= 16'b0;  
            state <= 2'b00;  
        end else begin  
            case (state)  
                2'b00: begin  
                    // First clock cycle: Compute temporary values  
                    temp_approx <= (x0 + x1 + x2 + x3) >> 2;  
                    temp_detail <= (x0 - x1 + x2 - x3) >> 2;  
                    state <= 2'b01;  
                end  
                2'b01: begin  
                    // Second clock cycle: Output the final values  
                    approx <= temp_approx;  
                    detail <= temp_detail;  
                    state <= 2'b00;  
                end  
            endcase  
        end  
    end  
endmodule