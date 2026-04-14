module fixed_priority_arbiter (
    input clk,
    input rst_n,
    input [3:0] request,
    output reg [3:0] grant,
    output reg valid
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            grant <= 4'b0000;
            valid <= 0;
        end else begin
            case (request)
                4'b0001: begin grant <= 4'b0001; valid <= 1; end // Request 0
                4'b0010: begin grant <= 4'b0010; valid <= 1; end // Request 1
                4'b0100: begin grant <= 4'b0100; valid <= 1; end // Request 2
                4'b1000: begin grant <= 4'b1000; valid <= 1; end // Request 3
                4'b0011: begin grant <= 4'b0001; valid <= 1; end // Requests 0 and 1
                4'b0110: begin grant <= 4'b0010; valid <= 1; end // Requests 1 and 2
                4'b1100: begin grant <= 4'b0100; valid <= 1; end // Requests 2 and 3
                4'b1110: begin grant <= 4'b0001; valid <= 1; end // Requests 0, 1, and 2
                4'b1111: begin grant <= 4'b0001; valid <= 1; end // All requests
                default: begin grant <= 4'b0000; valid <= 0; end // No valid request
            endcase
        end
    end
endmodule