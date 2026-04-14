module csprng(  
    input clk,  
    input rst,  
    input [7:0] seed,  
    output reg [7:0] random_out  
);  
    reg [7:0] lfsr;  
    wire feedback;  

    // Feedback calculation based on taps (using polynomial x^8 + x^6 + x^5 + x^4 + 1)
    assign feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            lfsr <= seed;  
        end else begin  
            lfsr <= {lfsr[6:0], feedback};  
        end  
    end  

    always @(posedge clk) begin  
        random_out <= lfsr;  
    end  
endmodule