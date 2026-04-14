module phase_shifter(  
    input clk,  
    input [1:0] control,  
    input [3:0] data_in,  
    output reg [3:0] data_out  
);  
    always @(posedge clk) begin  
        case(control)  
            2'b00: data_out <= data_in;        // 0 degrees  
            2'b01: data_out <= {data_in[2:0], data_in[3]}; // 90 degrees  
            2'b10: data_out <= {data_in[1:0], data_in[3:2]}; // 180 degrees  
            2'b11: data_out <= {data_in[0], data_in[3:1]}; // 270 degrees  
            default: data_out <= data_in;  
        endcase  
    end  
endmodule