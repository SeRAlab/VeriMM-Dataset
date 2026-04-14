module piso_shift_register #(parameter WIDTH = 8) (  
    input wire clk,  
    input wire reset,  
    input wire load,  
    input wire shift,  
    input wire [WIDTH-1:0] data_in,  
    output reg serial_out  
);  
    reg [WIDTH-1:0] shift_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 0;  
            serial_out <= 0;  
        end else begin  
            if (load) begin  
                shift_reg <= data_in;  
            end  
            if (shift) begin  
                serial_out <= shift_reg[WIDTH-1];  
                shift_reg <= {shift_reg[WIDTH-2:0], 1'b0};  
            end  
        end  
    end  
endmodule