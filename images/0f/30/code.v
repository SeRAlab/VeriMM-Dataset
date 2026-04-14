module pipo_shift_register(  
    input wire clk,  
    input wire load,  
    input wire [4:0] data_in,  
    output reg [4:0] data_out  
);  
    reg [4:0] shift_reg;  

    always @(posedge clk) begin  
        if (load) begin  
            shift_reg <= data_in;  
        end else begin  
            shift_reg <= {shift_reg[3:0], 1'b0}; // Shift left and insert 0  
        end  
    end  

    always @(posedge clk) begin  
        data_out <= shift_reg;  
    end  
endmodule