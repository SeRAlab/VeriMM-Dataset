`timescale 1ns/1ps

module AStarAlgorithm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] current_state;
    reg [4:0] goal_state;
    reg [4:0] heuristic_value;
    reg rst;
    wire [4:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarAlgorithm dut (
        .clk(clk),
        .current_state(current_state),
        .goal_state(goal_state),
        .heuristic_value(heuristic_value),
        .rst(rst),
        .next_state(next_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            current_state = 5'd0;
            goal_state = 5'd0;
            heuristic_value = 5'd0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Current State Equals Goal State", test_num);
            reset_dut();
            current_state = 5'd15;
            goal_state = 5'd15;
            heuristic_value = 5'd2;
            @(posedge clk);
            #1 #1;
 check_outputs(5'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Goal Higher Than Current State", test_num);
            reset_dut();
            current_state = 5'd10;
            goal_state = 5'd20;
            heuristic_value = 5'd5;
            @(posedge clk);
            #1 #1;
 check_outputs(5'd11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Goal Lower Than Current State", test_num);
            reset_dut();
            current_state = 5'd20;
            goal_state = 5'd10;
            heuristic_value = 5'd3;
            @(posedge clk);
            #1 #1;
 check_outputs(5'd19);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Check - Start at 0", test_num);
            reset_dut();
            current_state = 5'd0;
            goal_state = 5'd31;
            heuristic_value = 5'd1;
            @(posedge clk);
            #1 #1;
 check_outputs(5'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Check - Start at 31", test_num);
            reset_dut();
            current_state = 5'd31;
            goal_state = 5'd0;
            heuristic_value = 5'd10;
            @(posedge clk);
            #1 #1;
 check_outputs(5'd30);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High Heuristic Value", test_num);
            reset_dut();
            current_state = 5'd5;
            goal_state = 5'd6;
            heuristic_value = 5'd31;
            @(posedge clk);
            #1 #1;
 check_outputs(5'd6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStarAlgorithm Testbench");
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
        input [4:0] expected_next_state;
        begin
            if (expected_next_state === (expected_next_state ^ next_state ^ expected_next_state)) begin
                $display("PASS");
                $display("  Outputs: next_state=%h",
                         next_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_state=%h",
                         expected_next_state);
                $display("  Got:      next_state=%h",
                         next_state);
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
        $dumpvars(0,clk, current_state, goal_state, heuristic_value, rst, next_state);
    end

endmodule
