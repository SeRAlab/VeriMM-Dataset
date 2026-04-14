module watchdog_timer (
    input wire clk,
    input wire reset,
    output reg timeout,
    output reg [3:0] count
);
    reg [3:0] preset_value = 4'b1010; // preset value of 10

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= preset_value;
            timeout <= 0;
        end else if (count > 0) begin
            count <= count - 1;
            timeout <= 0;
        end else begin
            timeout <= 1;
        end
    end
endmodule