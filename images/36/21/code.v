module chacha_counter (  
    input wire clk,  
    input wire reset,  
    input wire [31:0] key,  
    input wire [31:0] counter,  
    output reg [31:0] output_value  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            output_value <= 32'b0;  
        end else begin  
            output_value <= (key + counter) % 32'hFFFFFFFF;  
        end  
    end  
endmodule