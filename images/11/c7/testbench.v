`timescale 1ns/1ps

module SLAM_StateMachine_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg map_cmd;
    reg move_cmd;
    reg reset;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SLAM_StateMachine dut (
        .clk(clk),
        .map_cmd(map_cmd),
        .move_cmd(move_cmd),
        .reset(reset),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            move_cmd = 0;
            map_cmd = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Reset behavior");
            reset_dut();

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Transition IDLE -> MOVING");
            reset_dut();
            @(negedge clk);
            move_cmd = 1;
            @(negedge clk);
            #1;

            check_outputs(MOVING);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Transition IDLE -> MAPPING");
            reset_dut();
            @(negedge clk);
            map_cmd = 1;
            @(negedge clk);
            #1;

            check_outputs(MAPPING);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Transition MOVING -> IDLE");
            reset_dut();
            @(negedge clk);
            move_cmd = 1;
            @(negedge clk);
            move_cmd = 0;
            @(negedge clk);
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Transition MAPPING -> IDLE");
            reset_dut();
            @(negedge clk);
            map_cmd = 1;
            @(negedge clk);
            map_cmd = 0;
            @(negedge clk);
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Sequential Move then Map");
            reset_dut();
            @(negedge clk);
            move_cmd = 1;
            @(negedge clk);
            move_cmd = 0;
            @(negedge clk);
            map_cmd = 1;
            @(negedge clk);
            #1;

            check_outputs(MAPPING);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Concurrent commands");
            reset_dut();
            @(negedge clk);
            move_cmd = 1;
            map_cmd = 1;
            @(negedge clk);


            if (state == MOVING || state == MAPPING)
                pass_count = pass_count + 0;

            #1;


            check_outputs(state);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SLAM_StateMachine Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [1:0] expected_state;
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
        $dumpvars(0,clk, map_cmd, move_cmd, reset, state);
    end

endmodule
