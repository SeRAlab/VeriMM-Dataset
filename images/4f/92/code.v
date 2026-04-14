module edge_detector (
        input clk,
        input sig,
        output edge);

    reg sig_dly;

    always @(posedge clk) begin
        sig_dly <= sig;
    end

    assign edge = sig & ~sig_dly;

endmodule