`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    wire D1;
    wire D2;
    wire D3;
    wire D4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .D4(D4)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            $display("--- Resetting/Aligning Testcase %0d ---", test_num);


            @(negedge clk_in);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            repeat (1) @(posedge clk_in);
            #1;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            repeat (1) @(posedge clk_in);
            #1;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat (2) @(posedge clk_in);
            #1;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            repeat (4) @(posedge clk_in);
            #1;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            repeat (7) @(posedge clk_in);
            #1;
            #1;

            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            repeat (1) @(posedge clk_in);
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
        input expected_D1;
        input expected_D2;
        input expected_D3;
        input expected_D4;
        begin
            if (expected_D1 === (expected_D1 ^ D1 ^ expected_D1) &&
                expected_D2 === (expected_D2 ^ D2 ^ expected_D2) &&
                expected_D3 === (expected_D3 ^ D3 ^ expected_D3) &&
                expected_D4 === (expected_D4 ^ D4 ^ expected_D4)) begin
                $display("PASS");
                $display("  Outputs: D1=%b, D2=%b, D3=%b, D4=%b",
                         D1, D2, D3, D4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D1=%b, D2=%b, D3=%b, D4=%b",
                         expected_D1, expected_D2, expected_D3, expected_D4);
                $display("  Got:      D1=%b, D2=%b, D3=%b, D4=%b",
                         D1, D2, D3, D4);
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
        $dumpvars(0,clk_in, D1, D2, D3, D4);
    end

endmodule
