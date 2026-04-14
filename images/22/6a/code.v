module pcie_endpoint_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire valid,
    output reg [15:0] data_out,
    output reg ready
);

    reg [1:0] state;

    localparam IDLE = 2'b00;
    localparam LATCH = 2'b01;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data_out <= 16'b0;
            ready <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    ready <= 1'b1;
                    if (valid) begin
                        state <= LATCH;
                        ready <= 1'b0;
                    end
                end
                LATCH: begin
                    data_out <= {data_in, 8'b0}; // Latch data with 8 bits extension
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule