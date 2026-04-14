`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg step;
    wire coil1;
    wire coil2;
    wire coil3;
    wire coil4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dir(dir),
        .step(step),
        .coil1(coil1),
        .coil2(coil2),
        .coil3(coil3),
        .coil4(coil4)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            step = 0;
            dir = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Idle state check (step=0)", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Clockwise rotation - Step 1", test_num);
            reset_dut();
            dir = 1;
            step = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Clockwise rotation - Step 2", test_num);
            reset_dut();
            dir = 1;
            step = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Clockwise rotation - Step 4", test_num);
            reset_dut();
            dir = 1;
            step = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Counter-Clockwise rotation - Step 1", test_num);
            reset_dut();
            dir = 0;
            step = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Counter-Clockwise rotation - Step 2 (Wrapped)", test_num);
            reset_dut();
            dir = 0;
            step = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Counter-Clockwise rotation - Step 4", test_num);
            reset_dut();
            dir = 0;
            step = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Stop motor mid-sequence", test_num);
            reset_dut();
            dir = 1;
            step = 1;
            repeat(2) @(posedge clk);
            #1;
            step = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: Direction change (CW then CCW)", test_num);
            reset_dut();
            dir = 1;
            step = 1;
            repeat(2) @(posedge clk);
            #1;
            dir = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0, 0);
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
        input expected_coil1;
        input expected_coil2;
        input expected_coil3;
        input expected_coil4;
        begin
            if (expected_coil1 === (expected_coil1 ^ coil1 ^ expected_coil1) &&
                expected_coil2 === (expected_coil2 ^ coil2 ^ expected_coil2) &&
                expected_coil3 === (expected_coil3 ^ coil3 ^ expected_coil3) &&
                expected_coil4 === (expected_coil4 ^ coil4 ^ expected_coil4)) begin
                $display("PASS");
                $display("  Outputs: coil1=%b, coil2=%b, coil3=%b, coil4=%b",
                         coil1, coil2, coil3, coil4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: coil1=%b, coil2=%b, coil3=%b, coil4=%b",
                         expected_coil1, expected_coil2, expected_coil3, expected_coil4);
                $display("  Got:      coil1=%b, coil2=%b, coil3=%b, coil4=%b",
                         coil1, coil2, coil3, coil4);
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
        $dumpvars(0,clk, dir, step, coil1, coil2, coil3, coil4);
    end

endmodule
