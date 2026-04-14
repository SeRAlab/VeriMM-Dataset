module top_module(
    input clk,   // Added input for clock signal
    input A,
    input B,
    input C,
    input D,
    output reg Y
);// define states
    parameter IDLE = 2'b00;
    parameter A_STATE = 2'b01;
    parameter AB_STATE = 2'b10;
    parameter ABC_STATE = 2'b11;
    
    // state register and next state logic
    reg [1:0] state, next_state;
    
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: if (A) next_state = A_STATE;
            A_STATE: if (B) next_state = AB_STATE;
            AB_STATE: if (C) next_state = ABC_STATE;
            ABC_STATE: if (D) next_state = IDLE;
        endcase
    end
    
    // output logic
    always @(*) begin
        Y = (state == ABC_STATE);
    end
    
    // update state
    always @(posedge clk) begin
        state <= next_state;
    end

endmodule