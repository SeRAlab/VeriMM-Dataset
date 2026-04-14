`timescale 1ns/1ps

module robot_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg obstacle_detected;
    reg reset;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    robot_fsm dut (
        .clk(clk),
        .obstacle_detected(obstacle_detected),
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
        reset = 1;
        obstacle_detected = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Reset to IDLE", test_num);
        reset_dut();


        #1;



        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: IDLE to MOVE_FORWARD (No obstacle)", test_num);
        reset_dut();
        obstacle_detected = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: IDLE to TURN_RIGHT (Obstacle detected)", test_num);
        reset_dut();
        obstacle_detected = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(2'b11);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: MOVE_FORWARD to TURN_RIGHT", test_num);
        reset_dut();
        obstacle_detected = 0;
        @(posedge clk);
        obstacle_detected = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: TURN_RIGHT to MOVE_FORWARD", test_num);
        reset_dut();
        obstacle_detected = 1;
        @(posedge clk);
        obstacle_detected = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Maintain MOVE_FORWARD", test_num);
        reset_dut();
        obstacle_detected = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1 #1;
 check_outputs(2'b01);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Maintain TURN_RIGHT", test_num);
        reset_dut();
        obstacle_detected = 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1 #1;
 check_outputs(2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Reset mid-operation", test_num);
        reset_dut();
        obstacle_detected = 1;
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(2'b00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("robot_fsm Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,clk, obstacle_detected, reset, state);
    end

endmodule
