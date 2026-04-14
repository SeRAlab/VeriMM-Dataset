module mpc_controller(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] current_state,  
    input wire [7:0] reference_state,  
    output reg [7:0] control_output  
);  
    reg [7:0] predicted_state;  
    reg [7:0] error;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            control_output <= 8'd0;  
            predicted_state <= 8'd0;  
        end else begin  
            error <= reference_state - current_state;  
            predicted_state <= predicted_state + error;  
            control_output <= predicted_state;  
        end  
    end  
endmodule