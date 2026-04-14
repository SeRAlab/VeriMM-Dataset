module reset_controller(
    input clk,
    input nreset, // active-low reset
    output reg stable
);
    reg [2:0] count; // 3-bit counter to count clock cycles

    always @(posedge clk or negedge nreset) begin
        if (!nreset) begin
            count <= 3'b000;
            stable <= 0;
        end else if (count < 3'b101) begin // Count up to 5
            count <= count + 1;
            stable <= 0;
        end else begin
            stable <= 1; // System is stable after 5 cycles
        end
    end
endmodule