module counter (
    input CLK, RESET, LOAD,
    input [7:0] LOAD_DATA,
    output reg [7:0] COUNT
);

    always @(posedge CLK) begin
        if (RESET) begin
            COUNT <= 8'b0;
        end
        else if (LOAD) begin
            COUNT <= LOAD_DATA;
        end
        else begin
            COUNT <= COUNT + 1;
        end
    end

endmodule