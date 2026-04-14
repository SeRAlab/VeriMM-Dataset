module JK_FF (  
    input wire J,  
    input wire K,  
    input wire clk,  
    input wire reset,  
    output reg Q  
);  
    always @(posedge clk or negedge reset) begin  
        if (!reset)  
            Q <= 0;  
        else begin  
            case ({J, K})  
                2'b00: Q <= Q;  
                2'b01: Q <= 0;  
                2'b10: Q <= 1;  
                2'b11: Q <= ~Q;  
            endcase  
        end  
    end  
endmodule