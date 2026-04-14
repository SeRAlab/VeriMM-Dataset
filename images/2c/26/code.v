module piso_shift_register(  
    input wire clk,  
    input wire load,  
    input wire [4:0] parallel_data,  
    output reg serial_out  
);  
    reg [4:0] shift_reg;  
    integer count;  

    always @(posedge clk) begin  
        if (load) begin  
            shift_reg <= parallel_data;  
            count <= 5;  
        end else if (count > 0) begin  
            serial_out <= shift_reg[4];  
            shift_reg <= {shift_reg[3:0], 1'b0};  
            count <= count - 1;  
        end  
    end  
endmodule