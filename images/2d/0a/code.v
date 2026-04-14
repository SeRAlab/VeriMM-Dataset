module frequency_divider(  
    input clk,       // Input clock  
    input reset,     // Reset signal  
    output reg out   // Output clock at half frequency  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            out <= 0;  
        end else begin  
            out <= ~out;  
        end  
    end  
endmodule