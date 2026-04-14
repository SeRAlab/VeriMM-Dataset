`timescale 1ns/1ps

module AStarSearch_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] current_x;
    reg [2:0] current_y;
    reg [24:0] obstacles;
    reg [2:0] target_x;
    reg [2:0] target_y;
    wire [2:0] next_x;
    wire [2:0] next_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarSearch dut (
        .current_x(current_x),
        .current_y(current_y),
        .obstacles(obstacles),
        .target_x(target_x),
        .target_y(target_y),
        .next_x(next_x),
        .next_y(next_y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Direct horizontal move (Right)", test_num);
            current_x = 3'd0; current_y = 3'd0;
            target_x = 3'd4;  target_y = 3'd0;
            obstacles = 25'b0;

            #1;


            check_outputs(3'd1, 3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Direct vertical move (Down)", test_num);
            current_x = 3'd2; current_y = 3'd1;
            target_x = 3'd2;  target_y = 3'd4;
            obstacles = 25'b0;

            #1;


            check_outputs(3'd2, 3'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Simple obstacle avoidance", test_num);
            current_x = 3'd1; current_y = 3'd1;
            target_x = 3'd3;  target_y = 3'd1;


            obstacles = (25'b1 << 7);





            #1;






            check_outputs(3'd1, 3'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Already at target", test_num);
            current_x = 3'd2; current_y = 3'd2;
            target_x = 3'd2;  target_y = 3'd2;
            obstacles = 25'b0;

            #1;


            check_outputs(3'd2, 3'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Move from corner with obstacles", test_num);
            current_x = 3'd4; current_y = 3'd4;
            target_x = 3'd0;  target_y = 3'd0;


            obstacles = (25'b1 << 23);

            #1;


            check_outputs(3'd4, 3'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Trapped path (Three sides blocked)", test_num);
            current_x = 3'd2; current_y = 3'd2;
            target_x = 3'd4;  target_y = 3'd4;


            obstacles = (25'b1 << 13) | (25'b1 << 7) | (25'b1 << 11);
            #1;

            check_outputs(3'd2, 3'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Boundary check (Top-Left)", test_num);
            current_x = 3'd0; current_y = 3'd0;
            target_x = 3'd1;  target_y = 3'd1;
            obstacles = 25'b0;


            #1;



            check_outputs(3'd1, 3'd0);
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
        input [2:0] expected_next_x;
        input [2:0] expected_next_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_x === (expected_next_x ^ next_x ^ expected_next_x) &&
                expected_next_y === (expected_next_y ^ next_y ^ expected_next_y)) begin
                $display("PASS");
                $display("  Outputs: next_x=%h, next_y=%h",
                         next_x, next_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_x=%h, next_y=%h",
                         expected_next_x, expected_next_y);
                $display("  Got:      next_x=%h, next_y=%h",
                         next_x, next_y);
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

endmodule
