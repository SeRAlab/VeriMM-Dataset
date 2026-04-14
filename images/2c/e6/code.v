module pulse_generator #(parameter WIDTH = 5, parameter PERIOD = 20) (  
    input clk,  
    input start,  
    output reg pulse  
);  
    reg [31:0] counter;  
    reg generating;  
  
    always @(posedge clk) begin  
        if (start) begin  
            generating <= 1;  
            counter <= 0;  
            pulse <= 1;  
        end else if (generating) begin  
            if (counter < WIDTH) begin  
                counter <= counter + 1;  
            end else if (counter < PERIOD) begin  
                counter <= counter + 1;  
                pulse <= 1;  
            end else begin  
                generating <= 0;  
                pulse <= 0;  
            end  
        end  
    end  
endmodule