module interrupt_controller (
    input wire reg_int,
    input wire high_int,
    input wire enable,
    input wire ack,
    output reg interrupt_out
);
    reg high_priority_active;
    reg regular_active;

    always @(posedge enable or posedge ack) begin
        if (ack) begin
            interrupt_out <= 0;
            high_priority_active <= 0;
            regular_active <= 0;
        end else if (enable) begin
            if (high_int) begin
                interrupt_out <= 1;
                high_priority_active <= 1;
                regular_active <= 0;
            end else if (reg_int && !high_priority_active) begin
                interrupt_out <= 1;
                regular_active <= 1;
            end else begin
                interrupt_out <= 0;
            end
        end
    end
endmodule