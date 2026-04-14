module top_module(
    input clk,
    input reset,
    input voltage,
    output power_good
);reg pg;
    wire pg_and;
    wire voltage_not;
    wire voltage_and;

    assign voltage_not = ~voltage;
    assign voltage_and = voltage & voltage_not;
    and (pg_and, voltage_and, clk);
    buf (power_good, pg_and);

    always @(posedge clk) begin
        if (reset) begin
            pg <= 0;
        end else begin
            pg <= pg_and;
        end
    end

endmodule