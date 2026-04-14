module sync_up_counter4 (
    input clk,
    input en,
    output reg [3:0] count
);

    always_ff @(posedge clk) begin
        if (en)
            count <= count + 1;
    end

endmodule