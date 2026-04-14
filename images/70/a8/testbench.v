`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire green_ew;
    wire green_ns;
    wire yellow_ew;
    wire yellow_ns;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .green_ew(green_ew),
        .green_ns(green_ns),
        .yellow_ew(yellow_ew),
        .yellow_ns(yellow_ns)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin



            #0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Running Testcase 001: NS Green Phase (Cycle 5/10)");

            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Running Testcase 002: NS Yellow Phase (Cycle 11/24)");


            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Running Testcase 003: EW Green Phase (Cycle 15/24)");



            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Running Testcase 004: EW Yellow Phase (Cycle 23/24)");


            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Running Testcase 005: Sequence Wrap-around (Cycle 25/24 -> NS Green)");


            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0, 0);
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
        input expected_green_ew;
        input expected_green_ns;
        input expected_yellow_ew;
        input expected_yellow_ns;
        begin
            if (expected_green_ew === (expected_green_ew ^ green_ew ^ expected_green_ew) &&
                expected_green_ns === (expected_green_ns ^ green_ns ^ expected_green_ns) &&
                expected_yellow_ew === (expected_yellow_ew ^ yellow_ew ^ expected_yellow_ew) &&
                expected_yellow_ns === (expected_yellow_ns ^ yellow_ns ^ expected_yellow_ns)) begin
                $display("PASS");
                $display("  Outputs: green_ew=%b, green_ns=%b, yellow_ew=%b, yellow_ns=%b",
                         green_ew, green_ns, yellow_ew, yellow_ns);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: green_ew=%b, green_ns=%b, yellow_ew=%b, yellow_ns=%b",
                         expected_green_ew, expected_green_ns, expected_yellow_ew, expected_yellow_ns);
                $display("  Got:      green_ew=%b, green_ns=%b, yellow_ew=%b, yellow_ns=%b",
                         green_ew, green_ns, yellow_ew, yellow_ns);
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
        $dumpvars(0,clk, green_ew, green_ns, yellow_ew, yellow_ns);
    end

endmodule
