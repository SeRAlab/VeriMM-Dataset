module round_robin_arbiter (
    input wire clk,
    input wire reset,
    input wire [3:0] req,
    output reg [3:0] grant
);
    reg [1:0] current_priority;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 4'b0000;
            current_priority <= 2'b00;
        end else begin
            grant <= 4'b0000;  // Reset grant
            if (req != 4'b0000) begin
                // Round Robin logic
                case (current_priority)
                    2'b00: if (req[0]) begin grant[0] <= 1; current_priority <= 2'b01; end
                           else if (req[1]) begin grant[1] <= 1; current_priority <= 2'b10; end
                           else if (req[2]) begin grant[2] <= 1; current_priority <= 2'b11; end
                           else if (req[3]) begin grant[3] <= 1; current_priority <= 2'b00; end
                    2'b01: if (req[1]) begin grant[1] <= 1; current_priority <= 2'b10; end
                           else if (req[2]) begin grant[2] <= 1; current_priority <= 2'b11; end
                           else if (req[3]) begin grant[3] <= 1; current_priority <= 2'b00; end
                           else if (req[0]) begin grant[0] <= 1; current_priority <= 2'b01; end
                    2'b10: if (req[2]) begin grant[2] <= 1; current_priority <= 2'b11; end
                           else if (req[3]) begin grant[3] <= 1; current_priority <= 2'b00; end
                           else if (req[0]) begin grant[0] <= 1; current_priority <= 2'b01; end
                           else if (req[1]) begin grant[1] <= 1; current_priority <= 2'b10; end
                    2'b11: if (req[3]) begin grant[3] <= 1; current_priority <= 2'b00; end
                           else if (req[0]) begin grant[0] <= 1; current_priority <= 2'b01; end
                           else if (req[1]) begin grant[1] <= 1; current_priority <= 2'b10; end
                           else if (req[2]) begin grant[2] <= 1; current_priority <= 2'b11; end
                endcase
            end
        end
    end
endmodule