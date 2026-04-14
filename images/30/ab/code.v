module CSPRNG (  
    input clk,  
    input rst,  
    input [3:0] seed,  
    output reg [3:0] random_out  
);  
    reg [3:0] lfsr;  
    wire feedback;  

    assign feedback = lfsr[3] ^ lfsr[2]; // Example feedback polynomial  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            lfsr <= seed;  
        end else begin  
            lfsr <= {lfsr[2:0], feedback};  
        end  
    end  

    always @(posedge clk) begin  
        random_out <= lfsr;  
    end  
endmodule