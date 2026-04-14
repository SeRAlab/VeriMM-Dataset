`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset;
    wire pattern_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .pattern_detected(pattern_detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic 101 sequence", test_num);
            reset_dut();

            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 0;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 0;
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No pattern sequence 111", test_num);
            reset_dut();
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 1;
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros sequence", test_num);
            reset_dut();
            @(negedge clk) data_in = 0;
            @(negedge clk) data_in = 0;
            @(negedge clk) data_in = 0;
            @(negedge clk) data_in = 0;
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overlapping 10101 sequence", test_num);
            reset_dut();

            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 0;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 0;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 0;
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pattern 101 followed by 0 (Return to 0)", test_num);
            reset_dut();

            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 0;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 0;
            @(negedge clk) data_in = 0;
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Long sequence with pattern at end 0101", test_num);
            reset_dut();
            @(negedge clk) data_in = 0;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 0;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 0;
            #1;
            #1;

            check_outputs(1);
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
        input expected_pattern_detected;
        begin
            if (expected_pattern_detected === (expected_pattern_detected ^ pattern_detected ^ expected_pattern_detected)) begin
                $display("PASS");
                $display("  Outputs: pattern_detected=%b",
                         pattern_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pattern_detected=%b",
                         expected_pattern_detected);
                $display("  Got:      pattern_detected=%b",
                         pattern_detected);
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
        $dumpvars(0,clk, data_in, reset, pattern_detected);
    end

endmodule
