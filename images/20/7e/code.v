module dma_controller (
    input wire clk,
    input wire rst_n,
    input wire REQ0,
    input wire REQ1,
    input wire START,
    output reg GNT0,
    output reg GNT1,
    output reg [7:0] DATA
);

reg [1:0] state, next_state;

localparam IDLE = 2'b00,
           GRANT0 = 2'b01,
           GRANT1 = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= next_state;
end

always @(*) begin
    case(state)
        IDLE: begin
            if (REQ0) begin
                next_state = GRANT0;
            end else if (REQ1) begin
                next_state = GRANT1;
            end else begin
                next_state = IDLE;
            end
        end
        GRANT0: begin
            GNT0 = 1;
            GNT1 = 0;
            if (START) begin
                DATA = 8'hAA; // Example data transfer
                next_state = IDLE;
            end else begin
                next_state = GRANT0;
            end
        end
        GRANT1: begin
            GNT0 = 0;
            GNT1 = 1;
            if (START) begin
                DATA = 8'hBB; // Example data transfer
                next_state = IDLE;
            end else begin
                next_state = GRANT1;
            end
        end
        default: next_state = IDLE;
    endcase
end

always @(*) begin
    GNT0 = 0;
    GNT1 = 0;
    case(state)
        GRANT0: GNT0 = 1;
        GRANT1: GNT1 = 1;
        default: ;
    endcase
end

endmodule