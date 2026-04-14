`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg HPI_INT;
    reg [1:0] iADDR;
    reg iCLK;
    reg iCS_N;
    reg [31:0] iDATA;
    reg iRD_N;
    reg iRST_N;
    reg iWR_N;
    wire [1:0] HPI_ADDR;
    wire HPI_CS_N;
    wire HPI_RD_N;
    wire HPI_RST_N;
    wire HPI_WR_N;
    wire [31:0] oDATA;
    wire oINT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .HPI_INT(HPI_INT),
        .iADDR(iADDR),
        .iCLK(iCLK),
        .iCS_N(iCS_N),
        .iDATA(iDATA),
        .iRD_N(iRD_N),
        .iRST_N(iRST_N),
        .iWR_N(iWR_N),
        .HPI_ADDR(HPI_ADDR),
        .HPI_CS_N(HPI_CS_N),
        .HPI_RD_N(HPI_RD_N),
        .HPI_RST_N(HPI_RST_N),
        .HPI_WR_N(HPI_WR_N),
        .oDATA(oDATA),
        .oINT(oINT)
    );

    // Clock generation (10ns period)
    initial begin
        iCLK = 0;
        forever #5 iCLK = ~iCLK;
    end

        task reset_dut;

    begin
        iRST_N = 0;
        iCS_N = 1;
        iRD_N = 1;
        iWR_N = 1;
        iADDR = 2'b00;
        iDATA = 32'h0;
        HPI_INT = 0;
        repeat (2) @(posedge iCLK);
        #1 iRST_N = 1;
        repeat (1) @(posedge iCLK);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Reset State Verification", test_num);
        reset_dut();


        #1;



        check_outputs(2'b00, 1'b1, 1'b1, 1'b1, 1'b1, 32'h0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Basic Write Operation", test_num);
        reset_dut();

        iCS_N = 0;
        iWR_N = 0;
        iRD_N = 1;
        iADDR = 2'b10;
        iDATA = 32'hDEADBEEF;

        @(posedge iCLK);
        #2;


        #1;



        check_outputs(2'b10, 1'b0, 1'b1, 1'b1, 1'b0, 32'hDEADBEEF, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Basic Read Operation", test_num);
        reset_dut();

        iCS_N = 0;
        iRD_N = 0;
        iWR_N = 1;
        iADDR = 2'b01;
        iDATA = 32'h0;

        @(posedge iCLK);
        #2;


        #1;



        check_outputs(2'b01, 1'b0, 1'b0, 1'b1, 1'b1, 32'h0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Interrupt Propagation", test_num);
        reset_dut();

        HPI_INT = 1;

        @(posedge iCLK);
        #2;


        #1;



        check_outputs(2'b00, 1'b1, 1'b1, 1'b1, 1'b1, 32'h0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Sequential Write and Address Change", test_num);
        reset_dut();


        iCS_N = 0; iWR_N = 0; iADDR = 2'b11; iDATA = 32'h12345678;
        @(posedge iCLK);


        iADDR = 2'b00; iDATA = 32'h87654321;
        @(posedge iCLK);
        #2;

        #1;


        check_outputs(2'b00, 1'b0, 1'b1, 1'b1, 1'b0, 32'h87654321, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [1:0] expected_HPI_ADDR;
        input expected_HPI_CS_N;
        input expected_HPI_RD_N;
        input expected_HPI_RST_N;
        input expected_HPI_WR_N;
        input [31:0] expected_oDATA;
        input expected_oINT;
        begin
            if (expected_HPI_ADDR === (expected_HPI_ADDR ^ HPI_ADDR ^ expected_HPI_ADDR) &&
                expected_HPI_CS_N === (expected_HPI_CS_N ^ HPI_CS_N ^ expected_HPI_CS_N) &&
                expected_HPI_RD_N === (expected_HPI_RD_N ^ HPI_RD_N ^ expected_HPI_RD_N) &&
                expected_HPI_RST_N === (expected_HPI_RST_N ^ HPI_RST_N ^ expected_HPI_RST_N) &&
                expected_HPI_WR_N === (expected_HPI_WR_N ^ HPI_WR_N ^ expected_HPI_WR_N) &&
                expected_oDATA === (expected_oDATA ^ oDATA ^ expected_oDATA) &&
                expected_oINT === (expected_oINT ^ oINT ^ expected_oINT)) begin
                $display("PASS");
                $display("  Outputs: HPI_ADDR=%h, HPI_CS_N=%b, HPI_RD_N=%b, HPI_RST_N=%b, HPI_WR_N=%b, oDATA=%h, oINT=%b",
                         HPI_ADDR, HPI_CS_N, HPI_RD_N, HPI_RST_N, HPI_WR_N, oDATA, oINT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HPI_ADDR=%h, HPI_CS_N=%b, HPI_RD_N=%b, HPI_RST_N=%b, HPI_WR_N=%b, oDATA=%h, oINT=%b",
                         expected_HPI_ADDR, expected_HPI_CS_N, expected_HPI_RD_N, expected_HPI_RST_N, expected_HPI_WR_N, expected_oDATA, expected_oINT);
                $display("  Got:      HPI_ADDR=%h, HPI_CS_N=%b, HPI_RD_N=%b, HPI_RST_N=%b, HPI_WR_N=%b, oDATA=%h, oINT=%b",
                         HPI_ADDR, HPI_CS_N, HPI_RD_N, HPI_RST_N, HPI_WR_N, oDATA, oINT);
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
        $dumpvars(0,HPI_INT, iADDR, iCLK, iCS_N, iDATA, iRD_N, iRST_N, iWR_N, HPI_ADDR, HPI_CS_N, HPI_RD_N, HPI_RST_N, HPI_WR_N, oDATA, oINT);
    end

endmodule
