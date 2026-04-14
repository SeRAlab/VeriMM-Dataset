`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg fin;
    reg rst;
    wire f16;
    wire f2;
    wire f4;
    wire f8;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fin(fin),
        .rst(rst),
        .f16(f16),
        .f2(f2),
        .f4(f4),
        .f8(f8)
    );

    // Clock generation (10ns period)
    initial begin
        fin = 0;
        forever #5 fin = ~fin;
    end

        task reset_dut;

        begin
            rst = 1;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking initial state after reset", test_num);
            reset_dut();
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Checking after 1 clock edge (Ripple Start)", test_num);
            reset_dut();
            @(posedge fin);
            #2;
            #1;

            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Checking after 2 clock edges", test_num);
            reset_dut();
            repeat(2) @(posedge fin);
            #2;
            #1;

            check_outputs(1, 0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Checking after 4 clock edges (f4 cycle)", test_num);
            reset_dut();
            repeat(4) @(posedge fin);
            #2;
            #1;

            check_outputs(1, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Checking after 8 clock edges (f8 cycle)", test_num);
            reset_dut();
            repeat(8) @(posedge fin);
            #2;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Checking after 12 clock edges", test_num);
            reset_dut();
            repeat(12) @(posedge fin);
            #2;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Checking after 15 clock edges", test_num);
            reset_dut();
            repeat(15) @(posedge fin);
            #2;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Checking after 16 clock edges (Full f16 cycle)", test_num);
            reset_dut();
            repeat(16) @(posedge fin);
            #2;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();
            repeat(5) @(posedge fin);
            rst = 1;
            #5;
            #1;

            check_outputs(0, 0, 0, 0);
            rst = 0;
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
        input expected_f16;
        input expected_f2;
        input expected_f4;
        input expected_f8;
        begin
            if (expected_f16 === (expected_f16 ^ f16 ^ expected_f16) &&
                expected_f2 === (expected_f2 ^ f2 ^ expected_f2) &&
                expected_f4 === (expected_f4 ^ f4 ^ expected_f4) &&
                expected_f8 === (expected_f8 ^ f8 ^ expected_f8)) begin
                $display("PASS");
                $display("  Outputs: f16=%b, f2=%b, f4=%b, f8=%b",
                         f16, f2, f4, f8);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f16=%b, f2=%b, f4=%b, f8=%b",
                         expected_f16, expected_f2, expected_f4, expected_f8);
                $display("  Got:      f16=%b, f2=%b, f4=%b, f8=%b",
                         f16, f2, f4, f8);
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
        $dumpvars(0,fin, rst, f16, f2, f4, f8);
    end

endmodule
