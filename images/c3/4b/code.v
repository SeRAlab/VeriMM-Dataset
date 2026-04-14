module counter_with_load_reset (
    input [3:0] DATA_IN,
    input LOAD,
    input CLK,
    input RESET,
    output reg [3:0] COUNT
);

    always @(posedge CLK, negedge RESET) begin
        if(RESET == 0) begin
            COUNT <= 4'b0;
        end
        else if(LOAD == 1) begin
            COUNT <= DATA_IN;
        end
        else begin
            COUNT <= COUNT + 1;
        end
    end

endmodule