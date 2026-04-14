`timescale 1ns/1ps

module AStarSearch_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] cost_to_adjacent;
    reg [3:0] current_state;
    reg reset;
    reg [3:0] target_state;
    wire [3:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarSearch dut (
        .clk(clk),
        .cost_to_adjacent(cost_to_adjacent),
        .current_state(current_state),
        .reset(reset),
        .target_state(target_state),
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
            cost_to_adjacent = 16'h0000;
            current_state = 4'd0;
            target_state = 4'd0;
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
            reset_dut();
            current_state = 4'd5;
            target_state = 4'd5;
            cost_to_adjacent = 16'h1111;

            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: Already at target state (5 -> 5)", test_num);
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            current_state = 4'd0;
            target_state = 4'd1;

            cost_to_adjacent = 16'h1FFF;

            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: Direct move right (0 -> 1)", test_num);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            current_state = 4'd5;
            target_state = 4'd7;



            cost_to_adjacent = 16'h2525;

            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: Heuristic preference (5 -> 6)", test_num);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            current_state = 4'd5;
            target_state = 4'd6;

            cost_to_adjacent = 16'hA F 1 F;

            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: Cost outweighs distance (5 -> 9)", test_num);
            #1;

            check_outputs(4'd9);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            current_state = 4'd10;
            target_state = 4'd2;

            cost_to_adjacent = 16'h8882;

            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: Boundary move North (10 -> 6)", test_num);
            #1;

            check_outputs(4'd6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStarSearch Testbench");
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
        $dumpvars(0,clk, cost_to_adjacent, current_state, reset, target_state, next_state);
    end

endmodule
