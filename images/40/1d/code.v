module LDO_Controller(
    input wire clk,
    input wire rst,
    input wire [7:0] Vin,        // Input voltage
    input wire [7:0] Vref,       // Reference voltage
    output reg switch_ctrl,       // Control signal for the switch
    output reg [7:0] Vout         // Output voltage
);
    parameter [1:0] IDLE = 2'b00, 
                    ON = 2'b01, 
                    OFF = 2'b10; 
    reg [1:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst) 
            state <= IDLE;
        else 
            state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (Vin < Vref) begin
                    next_state = ON;
                end else begin
                    next_state = OFF;
                end
            end
            ON: begin
                switch_ctrl = 1; // Turn on the switch
                Vout = Vin;      // Output equals input
                next_state = (Vin < Vref) ? ON : OFF;
            end
            OFF: begin
                switch_ctrl = 0; // Turn off the switch
                Vout = 8'b0;     // Output is zero
                next_state = (Vin < Vref) ? ON : OFF;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule