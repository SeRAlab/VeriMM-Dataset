module pcie_endpoint_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire data_valid,
    input wire complete,
    output reg [1:0] state
);
    // State encoding
    localparam IDLE   = 2'b00;
    localparam READ   = 2'b01;
    localparam WRITE  = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= READ;
                end
                READ: begin
                    if (data_valid) state <= WRITE;
                end
                WRITE: begin
                    if (complete) state <= IDLE;
                end
            endcase
        end
    end
endmodule