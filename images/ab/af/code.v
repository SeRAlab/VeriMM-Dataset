module top_module(
    output reg [1:0] grant_vector,
    input [3:0] req_vector,
    input enable,
    input clk,
    input reset
);reg [1:0] lru_state;
reg [1:0] lru_next_state;

always @(posedge clk) begin
    if (reset) begin
        lru_state <= 2'b00;
        grant_vector <= 2'b00;
    end else begin
        lru_state <= lru_next_state;
        grant_vector <= lru_state;
    end
end

always @(*) begin
    if (!enable) begin
        lru_next_state = 2'b00;
    end else if (req_vector[0]) begin
        lru_next_state = 2'b01;
    end else if (req_vector[1]) begin
        lru_next_state = 2'b10;
    end else if (req_vector[2] || req_vector[3]) begin
        if (lru_state == 2'b11) begin
            lru_next_state = 2'b11;
        end else if (lru_state == 2'b10) begin
            lru_next_state = (req_vector[2]) ? 2'b11 : 2'b10;
        end else if (lru_state == 2'b01) begin
            lru_next_state = (req_vector[3]) ? 2'b11 : 2'b01;
        end else begin // lru_state == 2'b00
            lru_next_state = (req_vector[2]) ? 2'b10 : 2'b01;
        end
    end else begin
        lru_next_state = 2'b00;
    end
end

endmodule