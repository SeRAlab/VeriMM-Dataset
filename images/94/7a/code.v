module top_module(
    input clock,
    output reg red,
    output reg amber,
    output reg green
);parameter on = 1, off = 0, red_tics = 35, amber_tics = 3, green_tics = 20;
reg [1:0] state;

always @(posedge clock) begin
    case(state)
        2'b00: begin  // red light
            red <= on;
            amber <= off;
            green <= off;
            if (red_tics == 1) begin
                state <= 2'b01;
            end else begin
                state <= 2'b00;
            end
        end
        2'b01: begin  // red and amber light
            red <= on;
            amber <= on;
            green <= off;
            if (amber_tics == 1) begin
                state <= 2'b10;
            end else begin
                state <= 2'b01;
            end
        end
        2'b10: begin  // green light
            red <= off;
            amber <= off;
            green <= on;
            if (green_tics == 1) begin
                state <= 2'b00;
            end else begin
                state <= 2'b10;
            end
        end
    endcase
end

initial begin
    state <= 2'b00;
end

endmodule