module temperature_shutdown(
    input [3:0] temperature,
    output reg shutdown
);
    always @* begin
        if (temperature > 4'b1010) // 10 in binary
            shutdown = 1;
        else
            shutdown = 0;
    end
endmodule