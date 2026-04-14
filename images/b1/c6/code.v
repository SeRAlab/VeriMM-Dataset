module top_module(
    input SDRD0,
    input [1:0] SDA_L,
    input [15:0] SDA_U,
    output [21:0] MA
);reg [7:0] RANGE_0 = 8'h80;    // Initialize memory ranges to default values
    reg [7:0] RANGE_1 = 8'h40;
    reg [7:0] RANGE_2 = 8'h20;
    reg [7:0] RANGE_3 = 8'h10;

    wire BANKSEL = SDA_U[15:8];

    assign MA = SDA_U[15] ?          // In mapped region ?
                    ~SDA_U[14] ?
                        {RANGE_3, SDA_U[13:11]} :                 // 8000~BFFF
                        ~SDA_U[13] ?
                            {1'b0, RANGE_2, SDA_U[12:11]} :       // C000~DFFF
                            ~SDA_U[12] ?
                                {2'b00, RANGE_1, SDA_U[11]} :     // E000~EFFF
                                {3'b000, RANGE_0} :                // F000~F7FF
                {6'b000000, SDA_U[15:11]};                          // Pass through

    always @(posedge SDRD0) begin
        case (SDA_L)
            0: RANGE_0 <= BANKSEL;
            1: RANGE_1 <= BANKSEL;
            2: RANGE_2 <= BANKSEL;
            3: RANGE_3 <= BANKSEL;
        endcase
    end

endmodule