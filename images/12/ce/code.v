module pulse_generator #(parameter PULSE_DURATION = 5) (  
    input wire clk,  
    input wire reset,  
    input wire trigger,  
    output reg pulse  
);  
    reg [3:0] count; // Counter for pulse duration  
    reg generating; // State to indicate pulse generation  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            pulse <= 0;  
            count <= 0;  
            generating <= 0;  
        end else if (trigger && !generating) begin  
            generating <= 1;  
            count <= 0;  
            pulse <= 1;  
        end else if (generating) begin  
            if (count < PULSE_DURATION - 1) begin  
                count <= count + 1;  
            end else begin  
                pulse <= 0;  
                generating <= 0;  
            end  
        end  
    end  
endmodule