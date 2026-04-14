`timescale 1ns/1ps

module AHB2WB_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] HADDR;
    reg HCLK;
    reg HREADY;
    reg HRESETn;
    reg HSEL;
    reg [2:0] HSIZE;
    reg [1:0] HTRANS;
    reg [31:0] HWDATA;
    reg HWRITE;
    reg wb_ack_i;
    reg [31:0] wb_dat_i;
    wire [31:0] HRDATA;
    wire HREADYOUT;
    wire HRESP;
    wire [31:0] wb_adr_o;
    wire wb_clk_o;
    wire wb_cyc_o;
    wire [31:0] wb_dat_o;
    wire wb_rst_o;
    wire [3:0] wb_sel_o;
    wire wb_stb_o;
    wire wb_we_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AHB2WB dut (
        .HADDR(HADDR),
        .HCLK(HCLK),
        .HREADY(HREADY),
        .HRESETn(HRESETn),
        .HSEL(HSEL),
        .HSIZE(HSIZE),
        .HTRANS(HTRANS),
        .HWDATA(HWDATA),
        .HWRITE(HWRITE),
        .wb_ack_i(wb_ack_i),
        .wb_dat_i(wb_dat_i),
        .HRDATA(HRDATA),
        .HREADYOUT(HREADYOUT),
        .HRESP(HRESP),
        .wb_adr_o(wb_adr_o),
        .wb_clk_o(wb_clk_o),
        .wb_cyc_o(wb_cyc_o),
        .wb_dat_o(wb_dat_o),
        .wb_rst_o(wb_rst_o),
        .wb_sel_o(wb_sel_o),
        .wb_stb_o(wb_stb_o),
        .wb_we_o(wb_we_o)
    );

    // Clock generation (10ns period)
    initial begin
        HCLK = 0;
        forever #5 HCLK = ~HCLK;
    end

        task reset_dut;

    begin
        HRESETn = 0;
        HADDR = 0;
        HREADY = 1;
        HSEL = 0;
        HSIZE = 3'b010;
        HTRANS = 2'b00;
        HWDATA = 0;
        HWRITE = 0;
        wb_ack_i = 0;
        wb_dat_i = 0;
        #20;
        HRESETn = 1;
        #10;
        @(posedge HCLK);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(
            32'h0,
            1'b1,
            1'b0,
            32'h0,
            HCLK,
            1'b0,
            32'h0,
            1'b0,
            4'h0,
            1'b0,
            1'b0
        );
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();


        @(posedge HCLK);
        HADDR  <= 32'hA000_0004;
        HWRITE <= 1'b1;
        HSEL   <= 1'b1;
        HTRANS <= 2'b10;
        HSIZE  <= 3'b010;


        @(posedge HCLK);
        HTRANS <= 2'b00;
        HWDATA <= 32'h1234_5678;
        wb_ack_i <= 1'b1;

        @(posedge HCLK);
        wb_ack_i <= 1'b0;
        HSEL     <= 1'b0;



        #1;




        check_outputs(32'h0, 1'b1, 1'b0, 32'hA000_0004, HCLK, 1'b0, 32'h1234_5678, 1'b0, 4'hF, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();


        @(posedge HCLK);
        HADDR  <= 32'hB000_1000;
        HWRITE <= 1'b0;
        HSEL   <= 1'b1;
        HTRANS <= 2'b10;
        HSIZE  <= 3'b010;


        @(posedge HCLK);
        HTRANS <= 2'b00;
        wb_dat_i <= 32'hCAFE_BABE;
        wb_ack_i <= 1'b1;

        @(posedge HCLK);
        wb_ack_i <= 1'b0;
        HSEL     <= 1'b0;

        #1;


        check_outputs(32'hCAFE_BABE, 1'b1, 1'b0, 32'hB000_1000, HCLK, 1'b0, 32'h0, 1'b0, 4'hF, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        @(posedge HCLK);
        HADDR  <= 32'hC000_0000;
        HWRITE <= 1'b1;
        HSEL   <= 1'b1;
        HTRANS <= 2'b10;

        @(posedge HCLK);
        HWDATA <= 32'h8765_4321;
        HTRANS <= 2'b00;
        wb_ack_i <= 1'b0;

        repeat(2) @(posedge HCLK);

        wb_ack_i <= 1'b1;
        @(posedge HCLK);
        wb_ack_i <= 1'b0;
        HSEL     <= 1'b0;

        #1;


        check_outputs(32'h0, 1'b1, 1'b0, 32'hC000_0000, HCLK, 1'b0, 32'h8765_4321, 1'b0, 4'hF, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();


        @(posedge HCLK);
        HADDR  <= 32'hD000_0001;
        HWRITE <= 1'b1;
        HSEL   <= 1'b1;
        HTRANS <= 2'b10;
        HSIZE  <= 3'b000;

        @(posedge HCLK);
        HWDATA <= 32'h0000_AA00;
        wb_ack_i <= 1'b1;

        @(posedge HCLK);
        wb_ack_i <= 1'b0;
        HSEL     <= 1'b0;


        #1;



        check_outputs(32'h0, 1'b1, 1'b0, 32'hD000_0001, HCLK, 1'b0, 32'h0000_AA00, 1'b0, 4'b0010, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();


        @(posedge HCLK);
        HADDR  <= 32'hE000_0002;
        HWRITE <= 1'b0;
        HSEL   <= 1'b1;
        HTRANS <= 2'b10;
        HSIZE  <= 3'b001;

        @(posedge HCLK);
        wb_dat_i <= 32'h5566_0000;
        wb_ack_i <= 1'b1;

        @(posedge HCLK);
        wb_ack_i <= 1'b0;
        HSEL     <= 1'b0;


        #1;



        check_outputs(32'h5566_0000, 1'b1, 1'b0, 32'hE000_0002, HCLK, 1'b0, 32'h0, 1'b0, 4'b1100, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();


        @(posedge HCLK);
        HADDR  <= 32'h100;
        HWRITE <= 1'b1;
        HSEL   <= 1'b1;
        HTRANS <= 2'b10;

        @(posedge HCLK);
        HWDATA <= 32'h1111_1111;

        HADDR  <= 32'h200;
        HWRITE <= 1'b0;
        wb_ack_i <= 1'b1;

        @(posedge HCLK);

        wb_dat_i <= 32'h2222_2222;
        wb_ack_i <= 1'b1;

        @(posedge HCLK);
        wb_ack_i <= 1'b0;
        HSEL     <= 1'b0;

        #1;


        check_outputs(32'h2222_2222, 1'b1, 1'b0, 32'h200, HCLK, 1'b0, 32'h1111_1111, 1'b0, 4'hF, 1'b0, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AHB2WB Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [31:0] expected_HRDATA;
        input expected_HREADYOUT;
        input expected_HRESP;
        input [31:0] expected_wb_adr_o;
        input expected_wb_clk_o;
        input expected_wb_cyc_o;
        input [31:0] expected_wb_dat_o;
        input expected_wb_rst_o;
        input [3:0] expected_wb_sel_o;
        input expected_wb_stb_o;
        input expected_wb_we_o;
        begin
            if (expected_HRDATA === (expected_HRDATA ^ HRDATA ^ expected_HRDATA) &&
                expected_HREADYOUT === (expected_HREADYOUT ^ HREADYOUT ^ expected_HREADYOUT) &&
                expected_HRESP === (expected_HRESP ^ HRESP ^ expected_HRESP) &&
                expected_wb_adr_o === (expected_wb_adr_o ^ wb_adr_o ^ expected_wb_adr_o) &&
                expected_wb_clk_o === (expected_wb_clk_o ^ wb_clk_o ^ expected_wb_clk_o) &&
                expected_wb_cyc_o === (expected_wb_cyc_o ^ wb_cyc_o ^ expected_wb_cyc_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o) &&
                expected_wb_rst_o === (expected_wb_rst_o ^ wb_rst_o ^ expected_wb_rst_o) &&
                expected_wb_sel_o === (expected_wb_sel_o ^ wb_sel_o ^ expected_wb_sel_o) &&
                expected_wb_stb_o === (expected_wb_stb_o ^ wb_stb_o ^ expected_wb_stb_o) &&
                expected_wb_we_o === (expected_wb_we_o ^ wb_we_o ^ expected_wb_we_o)) begin
                $display("PASS");
                $display("  Outputs: HRDATA=%h, HREADYOUT=%b, HRESP=%b, wb_adr_o=%h, wb_clk_o=%b, wb_cyc_o=%b, wb_dat_o=%h, wb_rst_o=%b, wb_sel_o=%h, wb_stb_o=%b, wb_we_o=%b",
                         HRDATA, HREADYOUT, HRESP, wb_adr_o, wb_clk_o, wb_cyc_o, wb_dat_o, wb_rst_o, wb_sel_o, wb_stb_o, wb_we_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HRDATA=%h, HREADYOUT=%b, HRESP=%b, wb_adr_o=%h, wb_clk_o=%b, wb_cyc_o=%b, wb_dat_o=%h, wb_rst_o=%b, wb_sel_o=%h, wb_stb_o=%b, wb_we_o=%b",
                         expected_HRDATA, expected_HREADYOUT, expected_HRESP, expected_wb_adr_o, expected_wb_clk_o, expected_wb_cyc_o, expected_wb_dat_o, expected_wb_rst_o, expected_wb_sel_o, expected_wb_stb_o, expected_wb_we_o);
                $display("  Got:      HRDATA=%h, HREADYOUT=%b, HRESP=%b, wb_adr_o=%h, wb_clk_o=%b, wb_cyc_o=%b, wb_dat_o=%h, wb_rst_o=%b, wb_sel_o=%h, wb_stb_o=%b, wb_we_o=%b",
                         HRDATA, HREADYOUT, HRESP, wb_adr_o, wb_clk_o, wb_cyc_o, wb_dat_o, wb_rst_o, wb_sel_o, wb_stb_o, wb_we_o);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,HADDR, HCLK, HREADY, HRESETn, HSEL, HSIZE, HTRANS, HWDATA, HWRITE, wb_ack_i, wb_dat_i, HRDATA, HREADYOUT, HRESP, wb_adr_o, wb_clk_o, wb_cyc_o, wb_dat_o, wb_rst_o, wb_sel_o, wb_stb_o, wb_we_o);
    end

endmodule
