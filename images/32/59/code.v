module pcie_sm (
    input clk,
    input reset,
    input start,
    input grant,
    input complete,
    output reg [1:0] state // 00: IDLE, 01: REQUEST, 10: GRANT, 11: DONE
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam REQUEST = 2'b01;
    localparam GRANT = 2'b10;
    localparam DONE = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) 
                        state <= REQUEST;
                end
                REQUEST: begin
                    if (grant) 
                        state <= GRANT;
                end
                GRANT: begin
                    if (complete) 
                        state <= DONE;
                end
                DONE: begin
                    state <= IDLE; // return to IDLE after DONE
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule