module pipeline_adder_shifter (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] data_in,  
    output reg [8:0] data_out  
);  
    reg [8:0] stage1;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            stage1 <= 9'b0;  
            data_out <= 9'b0;  
        end else begin  
            stage1 <= data_in + 8'd1; // Add 1 in the first stage  
            data_out <= stage1 << 1;   // Shift left by 1 in the second stage  
        end  
    end  
endmodule