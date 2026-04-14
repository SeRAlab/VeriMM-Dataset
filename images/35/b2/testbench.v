`timescale 1ns/1ps

module rrt_state_machine_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg goal_reached;
    reg reset;
    reg start_explore;
    wire [1:0] current_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_state_machine dut (
        .clk(clk),
        .goal_reached(goal_reached),
        .reset(reset),
        .start_explore(start_explore),
        .current_state(current_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_explore = 0;
            goal_reached = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Full Path IDLE -> EXPLORE -> GOAL");
            reset_dut();


            start_explore = 1;
            @(posedge clk);
            #1;
            start_explore = 0;


            goal_reached = 1;
            @(posedge clk);
            #1;
            goal_reached = 0;

            #1;


            check_outputs(GOAL);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Transition IDLE -> EXPLORE");
            reset_dut();

            start_explore = 1;
            @(posedge clk);
            #1;
            start_explore = 0;


            @(posedge clk);
            #1;

            #1;


            check_outputs(EXPLORE);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Stay in IDLE");
            reset_dut();

            start_explore = 0;
            goal_reached = 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Reset from EXPLORE state");
            reset_dut();


            start_explore = 1;
            @(posedge clk);
            #1;


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: EXPLORE remains until Goal Reached");
            reset_dut();


            start_explore = 1;
            @(posedge clk);
            #1;
            start_explore = 0;


            start_explore = 1;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(EXPLORE);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Return to IDLE from GOAL state via Reset");
            reset_dut();


            start_explore = 1;
            @(posedge clk);
            #1;
            start_explore = 0;
            goal_reached = 1;
            @(posedge clk);
            #1;


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

            #1;


            check_outputs(IDLE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_state_machine Testbench");
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
        input [1:0] expected_current_state;
        begin
            if (expected_current_state === (expected_current_state ^ current_state ^ expected_current_state)) begin
                $display("PASS");
                $display("  Outputs: current_state=%h",
                         current_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_state=%h",
                         expected_current_state);
                $display("  Got:      current_state=%h",
                         current_state);
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
        $dumpvars(0,clk, goal_reached, reset, start_explore, current_state);
    end

endmodule
