module pcie_endpoint_controller (
    input wire clk,
    input wire reset,
    input wire request,
    output reg [1:0] state // 00: IDLE, 01: REQUEST, 10: RESPONSE
);
    // State encoding
    localparam IDLE = 2'b00;
    localparam REQUEST = 2'b01;
    localparam RESPONSE = 2'b10;

    reg [1:0] next_state;
    integer counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counter <= 0;
        end else begin
            state <= next_state;
            if (state == REQUEST)
                counter <= counter + 1;
            else
                counter <= 0;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (request)
                    next_state = REQUEST;
                else
                    next_state = IDLE;
            end
            REQUEST: begin
                if (counter >= 4) // simulate processing time
                    next_state = RESPONSE;
                else
                    next_state = REQUEST;
            end
            RESPONSE: begin
                next_state = IDLE; // go back to IDLE after response
            end
            default: next_state = IDLE;
        endcase
    end
endmodule