module top_module(input [5:0] mux_arbitro_1,
                    input reset_L, destiny,
                    output reg [5:0] D0_out, D1_out);always@(*) begin
        if(~reset_L) begin
            D0_out = 0;
            D1_out = 0;
        end
        else begin
            if (destiny == 0) D0_out = mux_arbitro_1;
            else if (destiny == 1) D1_out = mux_arbitro_1;
        end
    end

endmodule