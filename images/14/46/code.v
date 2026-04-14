module pcie_endpoint_controller(
    input wire clk,
    input wire rst,
    input wire start,
    input wire data_request,
    input wire data_valid,
    output reg [1:0] state,
    output reg error
);
    localparam IDLE = 2'b00, ACTIVE = 2'b01, ERROR = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            error <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= ACTIVE;
                        error <= 0;
                    end
                end
                ACTIVE: begin
                    if (data_request) begin
                        if (data_valid) begin
                            // Process data successfully
                            state <= IDLE;
                        end else begin
                            // Processing error
                            error <= 1;
                            state <= ERROR;
                        end
                    end
                end
                ERROR: begin
                    // Remain in error state until reset
                    if (rst) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule