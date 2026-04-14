`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg r0;
    reg r1;
    reg r2;
    reg r3;
    reg [5:0] random_no;
    reg [3:0] s0;
    reg [4:0] s1;
    reg [5:0] s2;
    reg [5:0] s3;
    wire gr0;
    wire gr1;
    wire gr2;
    wire gr3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .r0(r0),
        .r1(r1),
        .r2(r2),
        .r3(r3),
        .random_no(random_no),
        .s0(s0),
        .s1(s1),
        .s2(s2),
        .s3(s3),
        .gr0(gr0),
        .gr1(gr1),
        .gr2(gr2),
        .gr3(gr3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            r0 = 0; r1 = 0; r2 = 0; r3 = 0;
            random_no = 0;
            s0 = 0; s1 = 0; s2 = 0; s3 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTestcase %0d: Enable signal is low", test_num);
            enable = 0;
            r0 = 1; r1 = 1; r2 = 1; r3 = 1;
            s0 = 10; s1 = 20; s2 = 30; s3 = 40;
            random_no = 5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTestcase %0d: Random number in gr0 interval", test_num);
            enable = 1;
            r0 = 1; r1 = 1; r2 = 1; r3 = 1;
            s0 = 10; s1 = 20; s2 = 30; s3 = 40;
            random_no = 5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTestcase %0d: Random number in gr1 interval", test_num);
            enable = 1;
            r0 = 1; r1 = 1; r2 = 1; r3 = 1;
            s0 = 10; s1 = 20; s2 = 30; s3 = 40;
            random_no = 15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTestcase %0d: Random number in gr2 interval", test_num);
            enable = 1;
            r0 = 1; r1 = 1; r2 = 1; r3 = 1;
            s0 = 10; s1 = 20; s2 = 30; s3 = 40;
            random_no = 25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nTestcase %0d: Random number in gr3 interval", test_num);
            enable = 1;
            r0 = 1; r1 = 1; r2 = 1; r3 = 1;
            s0 = 10; s1 = 20; s2 = 30; s3 = 40;
            random_no = 35;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("\nTestcase %0d: Random number exceeds all thresholds", test_num);
            enable = 1;
            r0 = 1; r1 = 1; r2 = 1; r3 = 1;
            s0 = 8; s1 = 16; s2 = 32; s3 = 48;
            random_no = 60;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("\nTestcase %0d: Selection flag r0 is low, skipping first interval", test_num);
            enable = 1;
            r0 = 0; r1 = 1; r2 = 1; r3 = 1;
            s0 = 10; s1 = 20; s2 = 30; s3 = 40;
            random_no = 5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("\nTestcase %0d: Random number exactly equals threshold s0", test_num);
            enable = 1;
            r0 = 1; r1 = 1; r2 = 1; r3 = 1;
            s0 = 12; s1 = 24; s2 = 36; s3 = 48;
            random_no = 12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("\nTestcase %0d: Maximum input values", test_num);
            enable = 1;
            r0 = 1; r1 = 1; r2 = 1; r3 = 1;
            s0 = 15; s1 = 31; s2 = 63; s3 = 63;
            random_no = 63;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 0);
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
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_gr0;
        input expected_gr1;
        input expected_gr2;
        input expected_gr3;
        begin
            if (expected_gr0 === (expected_gr0 ^ gr0 ^ expected_gr0) &&
                expected_gr1 === (expected_gr1 ^ gr1 ^ expected_gr1) &&
                expected_gr2 === (expected_gr2 ^ gr2 ^ expected_gr2) &&
                expected_gr3 === (expected_gr3 ^ gr3 ^ expected_gr3)) begin
                $display("PASS");
                $display("  Outputs: gr0=%b, gr1=%b, gr2=%b, gr3=%b",
                         gr0, gr1, gr2, gr3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gr0=%b, gr1=%b, gr2=%b, gr3=%b",
                         expected_gr0, expected_gr1, expected_gr2, expected_gr3);
                $display("  Got:      gr0=%b, gr1=%b, gr2=%b, gr3=%b",
                         gr0, gr1, gr2, gr3);
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
        $dumpvars(0,clk, enable, r0, r1, r2, r3, random_no, s0, s1, s2, s3, gr0, gr1, gr2, gr3);
    end

endmodule
