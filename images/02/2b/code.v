module dvfs_control(
    input [2:0] TEMP,
    input [2:0] LOAD,
    output reg [1:0] MODE
);
    always @(*) begin
        if (TEMP < 3 && LOAD < 3)
            MODE = 2'b00; // LOW
        else if ((TEMP >= 3 && TEMP < 6) || (LOAD >= 3 && LOAD < 6))
            MODE = 2'b01; // MEDIUM
        else
            MODE = 2'b10; // HIGH
    end
endmodule