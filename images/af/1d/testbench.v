`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg datain_ch0;
    reg datain_ch1;
    reg datain_ch2;
    reg datain_ch3;
    reg rstn;
    wire serialout;
    wire testout0;
    wire testout1;
    wire testout2;
    wire testout3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .datain_ch0(datain_ch0),
        .datain_ch1(datain_ch1),
        .datain_ch2(datain_ch2),
        .datain_ch3(datain_ch3),
        .rstn(rstn),
        .serialout(serialout),
        .testout0(testout0),
        .testout1(testout1),
        .testout2(testout2),
        .testout3(testout3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            datain_ch0 = 0;
            datain_ch1 = 0;
            datain_ch2 = 0;
            datain_ch3 = 0;
            @(posedge clk);
            #2 rstn = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Inputs High (1111)", test_num);
            reset_dut();
            datain_ch3 = 1; datain_ch2 = 1; datain_ch1 = 1; datain_ch0 = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 1010 (ch3..ch0)", test_num);
            reset_dut();
            datain_ch3 = 1; datain_ch2 = 0; datain_ch1 = 1; datain_ch0 = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 0111 (ch3..ch0)", test_num);
            reset_dut();
            datain_ch3 = 0; datain_ch2 = 1; datain_ch1 = 1; datain_ch0 = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 1, 1, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Input Change", test_num);
            reset_dut();

            datain_ch3 = 0; datain_ch2 = 0; datain_ch1 = 1; datain_ch0 = 1;
            @(posedge clk);
            #1;

            datain_ch3 = 1; datain_ch2 = 1; datain_ch1 = 0; datain_ch0 = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(0, 0, 0, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Reset during operation", test_num);
            reset_dut();

            datain_ch3 = 1; datain_ch2 = 1; datain_ch1 = 1; datain_ch0 = 1;
            @(posedge clk);
            #1;

            rstn = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 0, 0);
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
        testcase006();
        
        
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
        input expected_serialout;
        input expected_testout0;
        input expected_testout1;
        input expected_testout2;
        input expected_testout3;
        begin
            if (expected_serialout === (expected_serialout ^ serialout ^ expected_serialout) &&
                expected_testout0 === (expected_testout0 ^ testout0 ^ expected_testout0) &&
                expected_testout1 === (expected_testout1 ^ testout1 ^ expected_testout1) &&
                expected_testout2 === (expected_testout2 ^ testout2 ^ expected_testout2) &&
                expected_testout3 === (expected_testout3 ^ testout3 ^ expected_testout3)) begin
                $display("PASS");
                $display("  Outputs: serialout=%b, testout0=%b, testout1=%b, testout2=%b, testout3=%b",
                         serialout, testout0, testout1, testout2, testout3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serialout=%b, testout0=%b, testout1=%b, testout2=%b, testout3=%b",
                         expected_serialout, expected_testout0, expected_testout1, expected_testout2, expected_testout3);
                $display("  Got:      serialout=%b, testout0=%b, testout1=%b, testout2=%b, testout3=%b",
                         serialout, testout0, testout1, testout2, testout3);
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
        $dumpvars(0,clk, datain_ch0, datain_ch1, datain_ch2, datain_ch3, rstn, serialout, testout0, testout1, testout2, testout3);
    end

endmodule
