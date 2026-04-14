module spi_controller (  
    input clk,  
    input rst,  
    input cs,  
    input data_in,  
    output reg data_out,  
    output reg valid  
);  
    reg [7:0] shift_reg;  
    integer bit_count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shift_reg <= 8'b0;  
            bit_count <= 0;  
            valid <= 0;  
            data_out <= 0;  
        end else if (!cs) begin  
            shift_reg <= {shift_reg[6:0], data_in};  
            bit_count <= bit_count + 1;  
            if (bit_count == 7) begin  
                valid <= 1;  
                data_out <= shift_reg;  
            end else begin  
                valid <= 0;  
            end  
        end else begin  
            valid <= 0;  
        end  
    end  
endmodule