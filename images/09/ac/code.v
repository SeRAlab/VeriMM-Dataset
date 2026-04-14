module pcie_controller (
    input clk,
    input reset,
    input [3:0] req,  // Request signals from up to 4 endpoints
    output reg [3:0] grant  // Grant signals to the endpoints
);

reg [1:0] current_state; // 2-bit state variable to indicate which request is being granted
reg [1:0] next_state;

parameter IDLE = 2'b00;
parameter GRANT_0 = 2'b01;
parameter GRANT_1 = 2'b10;
parameter GRANT_2 = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= IDLE;
        grant <= 4'b0000;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        IDLE: begin
            if (req[0]) begin
                next_state = GRANT_0;
            end else if (req[1]) begin
                next_state = GRANT_1;
            end else if (req[2]) begin
                next_state = GRANT_2;
            end else begin
                next_state = IDLE;
            end
        end
        GRANT_0: begin
            grant = 4'b0001;
            next_state = req[1] ? GRANT_1 : (req[2] ? GRANT_2 : IDLE);
        end
        GRANT_1: begin
            grant = 4'b0010;
            next_state = req[2] ? GRANT_2 : (req[0] ? GRANT_0 : IDLE);
        end
        GRANT_2: begin
            grant = 4'b0100;
            next_state = req[0] ? GRANT_0 : (req[1] ? GRANT_1 : IDLE);
        end
        default: begin
            grant = 4'b0000;
            next_state = IDLE;
        end
    endcase
end

endmodule