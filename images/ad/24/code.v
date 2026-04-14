module top_module(
    input wire[63:0] dataIn_data,
    input wire dataIn_last,
    output reg dataIn_ready,
    input wire dataIn_valid,
    output wire[63:0] dataOut_0_data,
    output wire dataOut_0_last,
    input wire dataOut_0_ready,
    output reg dataOut_0_valid,
    output wire[63:0] dataOut_1_data,
    output wire dataOut_1_last,
    input wire dataOut_1_ready,
    output reg dataOut_1_valid
);// Assign input data to both output streams
    assign dataOut_0_data = dataIn_data;
    assign dataOut_1_data = dataIn_data;

    // Assign input last to both output streams
    assign dataOut_0_last = dataIn_last;
    assign dataOut_1_last = dataIn_last;

    // Assign input valid to both output streams
    always @(dataIn_valid, dataOut_0_ready, dataOut_1_ready) begin
        dataOut_0_valid <= dataIn_valid & dataOut_0_ready;
        dataOut_1_valid <= dataIn_valid & dataOut_1_ready;
    end

    // Assign input ready based on output readiness
    always @(dataOut_0_ready, dataOut_1_ready) begin
        dataIn_ready <= dataOut_0_ready & dataOut_1_ready;
    end

endmodule