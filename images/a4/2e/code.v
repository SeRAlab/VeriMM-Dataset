module top_module(
    data_in,
    load,
    reset,
    clk,
    Q
);// Module ports
    input [3:0] data_in;
    input load;
    input reset;
    input clk;
    output reg [3:0] Q; // Make Q a reg since we are driving it in an always block

    // Local signals
    reg [3:0] Q_reg; // Change Q_reg to a reg type

    // Register behavior
    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            Q_reg <= 4'b0;
        end else if (load) begin
            Q_reg <= data_in;
        end
    end

    // Output
    assign Q = Q_reg; // Output current value of Q_reg to Q

endmodule