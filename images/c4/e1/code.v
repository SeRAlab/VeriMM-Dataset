module enable_dff (
    input data,
    input enable,
    output reg out
);

    always @(posedge enable or negedge enable)
    if (!enable) begin
        out <= 0;
    end else begin
        out <= data;
    end

endmodule