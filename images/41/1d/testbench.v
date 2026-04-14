`timescale 1ns/1ps

module state_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg trigger;
    wire [2:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    state_module dut (
        .clk(clk),
        .trigger(trigger),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            trigger = 1;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verify transition to State 3 after 3 trigger pulses", test_num);
            reset_dut();
            trigger = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verify State 3 holds while trigger is 0", test_num);
            reset_dut();
            trigger = 1;
            repeat(3) @(posedge clk);
            trigger = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verify transition from State 3 to 4", test_num);
            reset_dut();
            trigger = 1;
            repeat(3) @(posedge clk);
            trigger = 0;
            @(posedge clk);
            trigger = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Full sequence to State 6", test_num);
            reset_dut();

            trigger = 1;
            repeat(3) @(posedge clk);
            trigger = 0;
            repeat(3) @(posedge clk);
            trigger = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("state_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [2:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,clk, trigger, state);
    end

endmodule
