module CSPRNG(input clk, input reset, input [7:0] seed, output reg [7:0] random_out);  
    reg [7:0] lfsr;  
    wire feedback;  

    assign feedback = lfsr[0] ^ lfsr[1] ^ lfsr[2] ^ lfsr[3];  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr <= seed;  
        end else begin  
            lfsr <= {lfsr[6:0], feedback};  
        end  
    end  

    always @(posedge clk) begin  
        random_out <= lfsr;  
    end  
endmodule