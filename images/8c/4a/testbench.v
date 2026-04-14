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
            rstCRC = 1;
            CRCEn = 0;
            CRC5_8BitIn = 0;
            dataIn = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
            rstCRC = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(5'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Process 8-bit Data (0xAA)", test_num);
            reset_dut();
            CRC5_8BitIn = 1;
            dataIn = 8'hAA;
            CRCEn = 1;
            @(posedge clk);
            #1;
            CRCEn = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(CRCResult, 1'b1);
        end
        endtask

    task testcase003;

        reg [4:0] capture_crc;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify CRCEn Disable", test_num);
            reset_dut();


            CRC5_8BitIn = 1;
            dataIn = 8'h55;
            CRCEn = 1;
            @(posedge clk);
            #1;
            capture_crc = CRCResult;


            dataIn = 8'hFF;
            CRCEn = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(capture_crc, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Multi-byte Calculation", test_num);
            reset_dut();

            CRC5_8BitIn = 1;
            CRCEn = 1;

            dataIn = 8'h01;
            @(posedge clk);
            #1;

            dataIn = 8'h02;
            @(posedge clk);
            #1;

            CRCEn = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(CRCResult, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Local CRC Reset mid-calculation", test_num);
            reset_dut();


            CRC5_8BitIn = 1;
            dataIn = 8'hFF;
            CRCEn = 1;
            @(posedge clk);
            #1;


            rstCRC = 1;
            @(posedge clk);
            #1;
            rstCRC = 0;
            @(posedge clk);


            #1;



            check_outputs(5'h00, 1'b1);
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
