module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire start_tx,
    input wire [31:0] data_in,
    output reg transmitting,
    output reg [31:0] data_out
);
    reg [1:0] state;
    parameter IDLE = 2'b00, TRANSMITTING = 2'b01, DONE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            transmitting <= 0;
            data_out <= 32'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_tx) begin
                        transmitting <= 1;
                        data_out <= data_in;
                        state <= TRANSMITTING;
                    end
                end
                TRANSMITTING: begin
                    if (transmitting) begin
                        state <= DONE; // move to done state after 4 cycles
                    end
                end
                DONE: begin
                    transmitting <= 0;
                    state <= IDLE; // go back to idle
                end
            endcase
        end
    end
endmodule