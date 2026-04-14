module chacha_mixer(  
    input clk,  
    input rst,  
    input [31:0] data_in,  
    output reg [31:0] data_out  
);  
    reg [31:0] state;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 32'b0;  
        end else begin  
            state <= (state + data_in) ^ 32'h5A5A5A5A;  
        end  
    end  

    always @(posedge clk) begin  
        data_out <= state;  
    end  
endmodule