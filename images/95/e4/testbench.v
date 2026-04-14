`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CRC5_8BitIn;
    reg CRCEn;
    reg clk;
    reg [7:0] dataIn;
    reg rst;
    reg rstCRC;
    wire [4:0] CRCResult;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CRC5_8BitIn(CRC5_8BitIn),
        .CRCEn(CRCEn),
        .clk(clk),
        .dataIn(dataIn),
        .rst(rst),
        .rstCRC(rstCRC),
        .CRCResult(CRCResult),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            rstCRC = 0;
            CRCEn = 0;
            CRC5_8BitIn = 0;
            dataIn = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: System and CRC Reset check", test_num);
            reset_dut();

            rstCRC = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'h1f, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: 8-bit data processing (0x00)", test_num);
            reset_dut();

            rstCRC = 1; @(posedge clk); #1;
            rstCRC = 0;
            CRCEn = 1;
            CRC5_8BitIn = 1;
            dataIn = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'h0e, 1'b1);
        end
        endtask

    task testcase003;

        reg [4:0] prev_crc;
        begin
            test_num = 3;
            $display("Testcase %03d: CRC Enable signal check", test_num);
            reset_dut();

            rstCRC = 1; @(posedge clk); #1;
            rstCRC = 0;
            prev_crc = CRCResult;

            CRCEn = 0;
            dataIn = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(prev_crc, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Consecutive data updates", test_num);
            reset_dut();

            rstCRC = 1; @(posedge clk); #1;
            rstCRC = 0;
            CRCEn = 1;
            CRC5_8BitIn = 1;

            dataIn = 8'hAA; @(posedge clk); #1;
            dataIn = 8'h55; @(posedge clk); #1;

            #1;


            check_outputs(5'h07, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: 5-bit input mode check", test_num);
            reset_dut();

            rstCRC = 1; @(posedge clk); #1;
            rstCRC = 0;
            CRCEn = 1;
            CRC5_8BitIn = 0;
            dataIn = 8'h1F;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h1d, 1'b1);
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
        input [4:0] expected_CRCResult;
        input expected_ready;
        begin
            if (expected_CRCResult === (expected_CRCResult ^ CRCResult ^ expected_CRCResult) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: CRCResult=%h, ready=%b",
                         CRCResult, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CRCResult=%h, ready=%b",
                         expected_CRCResult, expected_ready);
                $display("  Got:      CRCResult=%h, ready=%b",
                         CRCResult, ready);
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
        $dumpvars(0,CRC5_8BitIn, CRCEn, clk, dataIn, rst, rstCRC, CRCResult, ready);
    end

endmodule
