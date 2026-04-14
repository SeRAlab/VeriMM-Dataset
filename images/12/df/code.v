module carrier_recovery (
    input wire clk,
    input wire modulated_signal,
    output reg recovered_carrier
);
    reg [1:0] state;
    
    always @(posedge clk) begin
        case (state)
            2'b00: begin
                recovered_carrier <= 0;
                if (modulated_signal) state <= 2'b01;
            end
            2'b01: begin
                recovered_carrier <= 1;
                if (!modulated_signal) state <= 2'b10;
            end
            2'b10: begin
                recovered_carrier <= 0;
                if (!modulated_signal) state <= 2'b00;
            end
        endcase
    end

    initial begin
        state = 2'b00;
    end
endmodule