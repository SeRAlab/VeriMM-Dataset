module shift_register(  
    input wire clk,  
    input wire reset,  
    input wire load,  
    input wire [1:0] shift_direction, // 00: No shift, 01: Left shift, 10: Right shift  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        data_out <= 8'b0;  
    end else if (load) begin  
        data_out <= data_in;  
    end else begin  
        case (shift_direction)  
            2'b00: data_out <= data_out; // No shift  
            2'b01: data_out <= {data_out[6:0], 1'b0}; // Left shift  
            2'b10: data_out <= {1'b0, data_out[7:1]}; // Right shift  
            default: data_out <= data_out; // Default case  
        endcase  
    end  
end  
endmodule