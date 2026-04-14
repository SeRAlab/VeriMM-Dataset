module top_module(
    input [15:0] a,
    input [15:0] dt,
    input enable,
    input rst,
    input clk,
    output reg [31:0] v,
    output reg busy
);reg [15:0] aprev;
reg [31:0] vprev;
reg [1:0] state;

always @(posedge clk) begin
    if (rst) begin
        v <= 0;
        busy <= 0;
        state <= 0;
    end else begin
        case (state)
            0: begin // wait for enable
                if (enable) begin
                    aprev <= a;
                    vprev <= 0;
                    state <= 1;
                    busy <= 1;
                end
            end
            1: begin // integrate
                v <= vprev + (dt * ((a + aprev) >> 1));
                aprev <= a;
                vprev <= v;
                if (enable) begin
                    state <= 1;
                    busy <= 1;
                end else begin
                    state <= 2;
                end
            end
            2: begin // done
                busy <= 0;
                state <= 0;
            end
        endcase
    end
end

endmodule