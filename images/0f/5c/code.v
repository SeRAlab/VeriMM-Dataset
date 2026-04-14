module pcie_endpoint_controller (
    input wire clk,
    input wire read_req,
    output reg data_ready
);
    reg [2:0] state; // Simple state to manage data readiness
    parameter IDLE = 3'b000, READY = 3'b001, DONE = 3'b010;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                data_ready <= 0;
                if (read_req) state <= READY;
            end
            READY: begin
                data_ready <= 0;
                state <= DONE; // transitions to done after one cycle
            end
            DONE: begin
                data_ready <= 1; // data is now ready
                state <= IDLE; // go back to idle
            end
        endcase
    end

endmodule