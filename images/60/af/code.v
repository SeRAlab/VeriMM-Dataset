module top_module(
    input wire          BUS_CLK,
    input wire          BUS_RST,
    inout wire  [31:0]  BUS_ADD,
    inout wire  [31:0]  BUS_DATA,
    input wire          BUS_RD,
    input wire          BUS_WR,
    output reg  [31:0]  count
);localparam COUNTER_ADDR = 32'h1000;
    
    reg [1:0] state;
    reg [31:0] prev_addr;
    
    // This signal will be used for byte access:
    wire BUS_BYTE_ACCESS;
    assign BUS_BYTE_ACCESS = (BUS_ADD < 32'h8000_0000) ? 1'b1 : 1'b0;
    
    always @(posedge BUS_CLK) begin
        if (BUS_RST) begin
            state <= 2'b00;
            prev_addr <= 32'h0;
            count <= 32'h0;
        end
        else begin
            case (state)
                2'b00: begin // IDLE state
                    if (BUS_WR && (BUS_ADD == COUNTER_ADDR)) begin
                        state <= 2'b01;
                        prev_addr <= BUS_ADD;
                    end
                end
                2'b01: begin // WAIT state
                    if (prev_addr == BUS_ADD) begin
                        state <= 2'b10;
                        count <= count + 1;
                    end
                    else if (BUS_WR && (BUS_ADD == COUNTER_ADDR)) begin
                        prev_addr <= BUS_ADD;
                    end
                    else begin
                        state <= 2'b00;
                    end
                end
                2'b10: begin // Count state
                    // Optional: Add logic for additional operation,
                    // like handling read or additional write cycles if needed.
                    state <= 2'b00; // Return to IDLE state after counting
                end
                default: begin
                    state <= 2'b00;
                end
            endcase
        end
    end

endmodule