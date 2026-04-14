module deserializer_32bit (  
    input clk,  
    input rst,  
    input [7:0] data_in,  
    input valid_in,  
    output reg [31:0] data_out,  
    output reg ready_out  
);  
    reg [1:0] count;  
    reg [31:0] shift_reg;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            count <= 0;  
            shift_reg <= 0;  
            data_out <= 0;  
            ready_out <= 0;  
        end else if (valid_in) begin  
            shift_reg <= {shift_reg[23:0], data_in};  
            count <= count + 1;  
            if (count == 3) begin  
                data_out <= shift_reg;  
                ready_out <= 1;  
                count <= 0;  
            end else begin  
                ready_out <= 0;  
            end  
        end  
    end  
endmodule