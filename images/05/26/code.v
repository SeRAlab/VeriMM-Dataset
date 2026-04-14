module sd_card_controller (
    input wire clk,
    input wire rst,
    input wire rw, // 1 for write, 0 for read
    input wire [7:0] data_in, // 8-bit data input
    output reg [7:0] data_out, // 8-bit data output
    output reg [1:0] state // 2-bit state output
);
    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10;
    reg [1:0] current_state, next_state;

    // State machine
    always @(posedge clk or posedge rst) begin
        if (rst) 
            current_state <= IDLE;
        else 
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (rw)
                    next_state = WRITE;
                else
                    next_state = READ;
            end
            READ: begin
                next_state = IDLE; // go back to IDLE after read
            end
            WRITE: begin
                next_state = IDLE; // go back to IDLE after write
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        case (current_state)
            READ: data_out <= 8'b10101010; // Dummy data for read
            WRITE: data_out <= data_in; // Echo the input on write
            default: data_out <= 8'b00000000;
        endcase
        state <= current_state; // Output current state
    end
endmodule