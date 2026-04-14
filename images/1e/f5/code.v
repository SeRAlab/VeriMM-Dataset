module phase_detector(  
    input wire clk,  
    input wire signal_A,  
    input wire signal_B,  
    output reg [1:0] phase_output  
);  
    reg signal_A_prev;  
    reg signal_B_prev;  

    always @(posedge clk) begin  
        signal_A_prev <= signal_A;  
        signal_B_prev <= signal_B;  

        if (signal_A_prev == signal_B_prev) begin  
            phase_output <= 2'b00; // In-phase  
        end else if (signal_A_prev && !signal_B_prev) begin  
            phase_output <= 2'b01; // A leading B  
        end else begin  
            phase_output <= 2'b10; // A lagging B  
        end  
    end  
endmodule