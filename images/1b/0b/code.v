module deadbeat_controller(  
    input clk,  
    input rst,  
    input [3:0] error,  
    output reg control_signal  
);  
    reg [1:0] state;  
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= S0;  
            control_signal <= 0;  
        end else begin  
            case (state)  
                S0: begin  
                    if (error != 4'b0000) begin  
                        control_signal <= 1;  
                        state <= S1;  
                    end  
                end  
                S1: begin  
                    if (error == 4'b0000) begin  
                        control_signal <= 0;  
                        state <= S2;  
                    end  
                end  
                S2: begin  
                    control_signal <= 0;  
                    state <= S3;  
                end  
                S3: begin  
                    // Hold state  
                end  
                default: state <= S0;  
            endcase  
        end  
    end  
endmodule