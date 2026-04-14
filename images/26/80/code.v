module shift_register(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] data_in,  
    output reg serial_out  
);  
    reg [7:0] shift_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 8'b0;  
        end else begin  
            shift_reg <= {shift_reg[6:0], data_in[0]};  
        end  
    end  

    always @(shift_reg) begin  
        serial_out <= shift_reg[0];  
    end  
endmodule