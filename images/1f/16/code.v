module fan_speed_controller(input [2:0] speed_input,  
                            input clk,  
                            output reg [2:0] speed_output);  

    always @(posedge clk) begin  
        speed_output <= speed_input;  
    end  
endmodule