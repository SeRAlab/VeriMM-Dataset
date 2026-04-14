module lfsr_32bit (  
    input wire clk,  
    input wire reset,  
    input wire [31:0] taps,  
    output reg [31:0] lfsr_out  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr_out <= 32'h1;  // Initialize to a non-zero value  
        end else begin  
            // Feedback logic based on the taps  
            lfsr_out <= {lfsr_out[30:0], ^(lfsr_out & taps)};  
        end  
    end  
endmodule