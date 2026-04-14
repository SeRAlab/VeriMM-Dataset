module dvfs_controller (  
    input clk,  
    input reset,  
    input [3:0] workload,  
    output reg [1:0] voltage_level,  
    output reg [1:0] frequency_level  
);  

    // States  
    localparam LOW = 2'b00;  
    localparam HIGH = 2'b01;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            voltage_level <= LOW;  
            frequency_level <= LOW;  
        end else begin  
            if (workload > 4'd8) begin  
                voltage_level <= HIGH;  
                frequency_level <= HIGH;  
            end else begin  
                voltage_level <= LOW;  
                frequency_level <= LOW;  
            end  
        end  
    end  
endmodule