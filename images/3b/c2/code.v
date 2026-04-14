module lfsr_8bit(  
    input clk,  
    input reset,  
    output reg lfsr_out  
);  
    reg [7:0] lfsr;  
    wire feedback;  

    // Feedback polynomial: x^8 + x^6 + x^5 + x^4 + 1  
    assign feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[6];  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr <= 8'b1; // Initialize to a non-zero value  
        end else begin  
            lfsr <= {lfsr[6:0], feedback};  
        end  
    end  

    always @(posedge clk) begin  
        lfsr_out <= lfsr[7];  
    end  
endmodule