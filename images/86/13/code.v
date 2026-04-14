module top_module(
    input  [15:0] Datain, // Data to Stack/Queue.
    output [15:0] Dataout, // Data from Stack/Queue.
    output Full,  // Stack is Full Signal, High = True.
    output Empty  // Stack is Empty Signal, High = True.
);// Parameters
    parameter MODE = 0; // Mode Selection: 0 for Stack mode, 1 for Queue mode.
    parameter DEPTH = (1 << ADDR_WIDTH); // Stack/Queue Size
    parameter SIZE = 16; // Word Size (8-32 bits)
    parameter ADDR_WIDTH = 3; // Address Size

    // Internal variables
    reg [ADDR_WIDTH-1:0] wr_pointer;
    reg [ADDR_WIDTH-1:0] rd_pointer;
    reg [ADDR_WIDTH:0] status_cnt;

    reg [SIZE-1:0] data_ram [0:DEPTH-1]; // Memory for stack/queue
    reg [SIZE-1:0] data_out;

    // State signals
    wire Wren;
    wire Rden;
    wire Rdclk;

    // Inputs, Outputs
    assign Full = (status_cnt == DEPTH);
    assign Empty = (status_cnt == 0);
    assign Wren = ((MODE == 0) && (status_cnt < DEPTH));
    assign Rden = ((MODE == 1) && (status_cnt > 0));
    assign Rdclk = 1'b1;

    always @(posedge Rdclk) begin
        if (Wren) begin
            data_ram[wr_pointer] <= Datain;
            wr_pointer <= wr_pointer + 1;
            status_cnt <= status_cnt + 1;
        end
        else if (Rden) begin
            data_out <= data_ram[rd_pointer];
            rd_pointer <= rd_pointer + 1;
            status_cnt <= status_cnt - 1;
        end
    end

    assign Dataout = data_out; // Output the data read from RAM

endmodule