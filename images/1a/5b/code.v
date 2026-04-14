module state_space_controller(
    input clk,
    input rst,
    input [2:0] state_in,
    output reg [2:0] control_out
);
    reg [1:0] current_state, next_state;

    // State encoding
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) 
            current_state <= S0;
        else 
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            S0: begin
                if (state_in == 3'b000) next_state = S1;
                else next_state = S0;
                control_out = 3'b001; // Output for state S0
            end
            S1: begin
                if (state_in == 3'b001) next_state = S2;
                else next_state = S0;
                control_out = 3'b010; // Output for state S1
            end
            S2: begin
                if (state_in == 3'b010) next_state = S3;
                else next_state = S0;
                control_out = 3'b100; // Output for state S2
            end
            S3: begin
                if (state_in == 3'b011) next_state = S0;
                else next_state = S0;
                control_out = 3'b111; // Output for state S3
            end
            default: begin
                next_state = S0;
                control_out = 3'b000;
            end
        endcase
    end
endmodule