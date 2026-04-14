module PISO #(parameter WIDTH = 8) (  
    input wire clk,  
    input wire load,  
    input wire [WIDTH-1:0] data_in,  
    output reg serial_out  
);  
    reg [WIDTH-1:0] shift_reg;  
  
    always @(posedge clk) begin  
        if (load) begin  
            shift_reg <= data_in;  
        end else begin  
            serial_out <= shift_reg[WIDTH-1];  
            shift_reg <= {shift_reg[WIDTH-2:0], 1'b0};  
        end  
    end  
endmodule