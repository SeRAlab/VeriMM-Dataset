module top_module(
    input wire Clock, Reset,
    input [7:0] DataIn,
    input DataInValid,
    output DataInReady,
    output [7:0] DataOut,
    output DataOutValid,
    input DataOutReady,
    output reg [31:0] ProcessorDataIn, // Changed to reg
    input [31:0] ProcessorDataOut,
    input [31:0] ProcessorAddress,
    input ProcessorMemRead, ProcessorMemWrite
);// Registers for data transfer
    reg [7:0] dataInReg = 8'h00;
    reg [7:0] dataOutReg = 8'h00;

    // Control signals
    wire pollingControlIn = ProcessorAddress == 32'hffff_0000;
    wire pollingControlOut = ProcessorAddress == 32'hffff_0008;
    wire uartDataInTransfer = DataInReady & DataInValid;
    wire uartDataOutTransfer = DataOutReady & DataOutValid;
    wire readingData = ProcessorMemRead & (ProcessorAddress == 32'hffff_0004);
    wire writingData = ProcessorMemWrite & (ProcessorAddress == 32'hffff_000c);

    // Control registers
    reg controlInReady = 1'b0;
    reg dataOutValid = 1'b0;

    always @(posedge Clock, posedge Reset) begin
        if (Reset) begin
            controlInReady <= 1'b0;
            dataOutValid <= 1'b0;
        end
        else begin
            if (readingData) begin
                // Use a separate output register for ProcessorDataOut if needed
                // Assuming it's desired to output data, we might need a different mechanism for that
                // Just simulating that here because we cannot write to a wire
                dataInReg <= ProcessorDataOut[7:0]; // Adjusted logic for reading
            end
            else if (writingData) begin
                dataOutReg <= ProcessorDataIn[7:0];
                dataOutValid <= 1'b1;
            end
            else begin
                dataOutValid <= 1'b0;
            end

            if (pollingControlIn) begin
                controlInReady <= 1'b1;
            end
            else if (pollingControlOut) begin
                ProcessorDataIn <= {24'b0, dataOutReg};
            end
            else begin
                if (uartDataInTransfer) begin
                    dataInReg <= DataIn;
                end
                ProcessorDataIn <= {24'b0, controlInReady};
            end
        end
    end

    assign DataInReady = ~controlInReady;
    assign DataOut = dataOutReg;
    assign DataOutValid = dataOutValid;

endmodule