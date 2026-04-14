module round_robin_arbiter (
    input clk,
    input reset,
    input [3:0] request,
    output reg [3:0] grant
);
    reg [1:0] current_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 4'b0000;
            current_state <= 2'b00;
        end else begin
            grant <= 4'b0000; // Reset grant
            case (current_state)
                2'b00: if (request[0]) begin
                           grant[0] <= 1;
                           current_state <= 2'b01;
                       end else if (request[1]) begin
                           grant[1] <= 1;
                           current_state <= 2'b10;
                       end else if (request[2]) begin
                           grant[2] <= 1;
                           current_state <= 2'b11;
                       end else if (request[3]) begin
                           grant[3] <= 1;
                           current_state <= 2'b00;
                       end
                2'b01: if (request[1]) begin
                           grant[1] <= 1;
                           current_state <= 2'b10;
                       end else if (request[2]) begin
                           grant[2] <= 1;
                           current_state <= 2'b11;
                       end else if (request[3]) begin
                           grant[3] <= 1;
                           current_state <= 2'b00;
                       end else if (request[0]) begin
                           grant[0] <= 1;
                           current_state <= 2'b01;
                       end
                2'b10: if (request[2]) begin
                           grant[2] <= 1;
                           current_state <= 2'b11;
                       end else if (request[3]) begin
                           grant[3] <= 1;
                           current_state <= 2'b00;
                       end else if (request[0]) begin
                           grant[0] <= 1;
                           current_state <= 2'b01;
                       end else if (request[1]) begin
                           grant[1] <= 1;
                           current_state <= 2'b10;
                       end
                2'b11: if (request[3]) begin
                           grant[3] <= 1;
                           current_state <= 2'b00;
                       end else if (request[0]) begin
                           grant[0] <= 1;
                           current_state <= 2'b01;
                       end else if (request[1]) begin
                           grant[1] <= 1;
                           current_state <= 2'b10;
                       end else if (request[2]) begin
                           grant[2] <= 1;
                           current_state <= 2'b11;
                       end
            endcase
        end
    end
endmodule