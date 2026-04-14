module pid_controller #(parameter DATA_WIDTH = 16) (  
    input wire clk,  
    input wire reset,  
    input wire [DATA_WIDTH-1:0] setpoint,  
    input wire [DATA_WIDTH-1:0] process_variable,  
    output reg [DATA_WIDTH-1:0] proportional,  
    output reg [DATA_WIDTH-1:0] integral,  
    output reg [DATA_WIDTH-1:0] derivative  
);  

reg [DATA_WIDTH-1:0] error;  
reg [DATA_WIDTH-1:0] last_process_variable;  
reg [DATA_WIDTH-1:0] integral_accumulator;  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        proportional <= 0;  
        integral <= 0;  
        derivative <= 0;  
        integral_accumulator <= 0;  
        last_process_variable <= 0;  
    end else begin  
        error <= setpoint - process_variable;  
        proportional <= error;  
        integral_accumulator <= integral_accumulator + error;  
        integral <= integral_accumulator;  
        derivative <= process_variable - last_process_variable;  
        last_process_variable <= process_variable;  
    end  
end  

endmodule