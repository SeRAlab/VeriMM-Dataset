`timescale 1ns/1ps

module AStar_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] current_state;
    reg [3:0] goal_state;
    reg reset;
    wire [3:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStar dut (
        .clk(clk),
        .current_state(current_state),
        .goal_state(goal_state),
        .reset(reset),
        .next_state(next_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_state = 4'd0;
            goal_state = 4'd0;
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
            $display("\nTest Case %0d: Move forward (0 -> 5)", test_num);
            reset_dut();
            current_state = 4'd0;
            goal_state = 4'd5;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Move backward (10 -> 5)", test_num);
            reset_dut();
            current_state = 4'd10;
            goal_state = 4'd5;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'd9);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Already at goal (7 -> 7)", test_num);
            reset_dut();
            current_state = 4'd7;
            goal_state = 4'd7;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary move (0 -> 1)", test_num);
            reset_dut();
            current_state = 4'd0;
            goal_state = 4'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary move (15 -> 14)", test_num);
            reset_dut();
            current_state = 4'd15;
            goal_state = 4'd14;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large step (2 -> 15)", test_num);
            reset_dut();
            current_state = 4'd2;
            goal_state = 4'd15;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStar Testbench");
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
        input [3:0] expected_next_state;
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
        $dumpvars(0,clk, current_state, goal_state, reset, next_state);
    end

endmodule
