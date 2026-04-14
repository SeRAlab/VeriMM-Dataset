`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ena;
    reg inclk;
    wire outclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ena(ena),
        .inclk(inclk),
        .outclk(outclk)
    );

    // Clock generation (10ns period)
    initial begin
        ena = 0;
        forever #5 ena = ~ena;
    end

        task reset_dut;

        begin
            ena = 0;
            #15;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            ena = 0;
            #20;
            $display("Testcase %0d: Enable low check", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            ena = 1;
            @(posedge inclk);
            #2;
            $display("Testcase %0d: First rising edge (should follow inclk)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            ena = 1;
            @(posedge inclk);
            @(posedge inclk);
            #2;
            $display("Testcase %0d: Second rising edge (should be inverse)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            ena = 1;
            @(posedge inclk);
            @(posedge inclk);
            @(posedge inclk);
            #2;
            $display("Testcase %0d: Third rising edge (should toggle to high)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            ena = 1;
            @(posedge inclk);
            #2;
            ena = 0;
            #2;
            $display("Testcase %0d: Mid-cycle disable check", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            ena = 1;
            repeat(4) @(posedge inclk);
            #2;
            $display("Testcase %0d: Fourth rising edge check (should be low)", test_num);
            #1;

            check_outputs(1'b0);
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
        input expected_outclk;
        begin
            if (expected_outclk === (expected_outclk ^ outclk ^ expected_outclk)) begin
                $display("PASS");
                $display("  Outputs: outclk=%b",
                         outclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outclk=%b",
                         expected_outclk);
                $display("  Got:      outclk=%b",
                         outclk);
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
        $dumpvars(0,ena, inclk, outclk);
    end

endmodule
