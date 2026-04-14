module shift_register (  
    input clk,  
    input reset,  
    input load,  
    input shift_dir,  
    input [7:0] data_in,  
    output reg [7:0] shift_reg  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 8'b0;  
        end else if (load) begin  
            shift_reg <= data_in;  
        end else begin  
            if (shift_dir == 0) begin  
                shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left  
            end else begin  
                shift_reg <= {1'b0, shift_reg[7:1]}; // Shift right  
            end  
        end  
    end  
endmodule