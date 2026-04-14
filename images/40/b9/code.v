module serializer_32bit (  
    input clk,  
    input rst,  
    input [7:0] data_in,  
    output reg [31:0] data_out  
);  
    reg [31:0] shift_reg;  
    integer count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shift_reg <= 32'b0;  
            data_out <= 32'b0;  
            count <= 0;  
        end else begin  
            shift_reg <= {shift_reg[23:0], data_in};  
            count <= count + 1;  
            if (count == 3) begin  
                data_out <= shift_reg;  
            end  
        end  
    end  
endmodule