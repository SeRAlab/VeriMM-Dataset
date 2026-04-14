module light_controller (
    input wire clk,
    input wire [1:0] control,
    output reg [1:0] light_state
);
    // State encoding
    parameter OFF = 2'b00, ON = 2'b01, BLINK = 2'b10;
    reg [1:0] current_state, next_state;

    // State transition logic
    always @(posedge clk) begin
        current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            OFF: begin
                if (control == 2'b01) next_state = ON;
                else next_state = OFF;
            end
            ON: begin
                if (control == 2'b01) next_state = OFF;
                else if (control == 2'b10) next_state = BLINK;
                else next_state = ON;
            end
            BLINK: begin
                if (control == 2'b01) next_state = OFF;
                else next_state = BLINK; // remains in BLINK state
            end
            default: next_state = OFF; // default state
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        case (current_state)
            OFF: light_state <= OFF;
            ON: light_state <= ON;
            BLINK: light_state <= BLINK;
        endcase
    end

    initial begin
        current_state = OFF; // Initial state
    end
endmodule