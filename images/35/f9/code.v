module sata_controller (
    input clk,
    input rst,
    input start,
    output reg [1:0] state
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter READ = 2'b01;
    parameter WRITE = 2'b10;
    parameter ERROR = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start)
                        state <= READ; // Transition to READ on start
                end
                READ: begin
                    // Example condition for transitioning to WRITE
                    state <= WRITE; // Just for simulation purposes
                end
                WRITE: begin
                    // Example condition for transitioning back to IDLE or ERROR
                    state <= ERROR; // Just for simulation purposes
                end
                ERROR: begin
                    state <= IDLE; // Reset to IDLE after ERROR
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule