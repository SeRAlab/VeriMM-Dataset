module GPIO_Controller (  
    input clk,  
    input reset,  
    input [1:0] command,  // 00: Read, 01: Set output  
    input [3:0] input_pin, // 4-bit input pins  
    input [3:0] output_data, // 4-bit data to set output pins  
    output reg [3:0] output_pin, // 4-bit output pins  
    output reg [3:0] read_data // 4-bit data read from input pins  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            output_pin <= 4'b0000;  
            read_data <= 4'b0000;  
        end else begin  
            case (command)  
                2'b00: read_data <= input_pin; // Read input pins  
                2'b01: output_pin <= output_data; // Set output pins  
                default:;  
            endcase  
        end  
    end  
endmodule