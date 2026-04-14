module divide_by_8(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [2:0] count;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 3'b000;  
            data_out <= 8'b00000000;  
        end else begin  
            if (count == 3'b111) begin  
                data_out <= data_in;  
                count <= 3'b000;  
            end else begin  
                count <= count + 1;  
            end  
        end  
    end  
endmodule