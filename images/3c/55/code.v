module AddRoundKey(  
    input wire clk,  
    input wire reset,  
    input wire [127:0] data_in,  
    input wire [127:0] round_key,  
    output reg [127:0] data_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 128'b0;  
        end else begin  
            data_out <= data_in ^ round_key;  
        end  
    end  
endmodule