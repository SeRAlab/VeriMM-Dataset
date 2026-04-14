`timescale 1ns/1ps

module AStarSelector_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] current_node;
    reg [3:0] heuristic_value;
    reg [3:0] target_node;
    wire [3:0] next_node;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarSelector dut (
        .current_node(current_node),
        .heuristic_value(heuristic_value),
        .target_node(target_node),
        .next_node(next_node)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Target ahead, low cost (f < target)", test_num);

            current_node = 4'd2;
            target_node = 4'd10;
            heuristic_value = 4'd1;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Target behind, high cost (f > target)", test_num);

            current_node = 4'd10;
            target_node = 4'd5;
            heuristic_value = 4'd2;
            #1;

            check_outputs(4'd9);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reached target exactly (f == target)", test_num);

            current_node = 4'd5;
            target_node = 4'd5;
            heuristic_value = 4'd0;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Optimal path reached via heuristic (f == target)", test_num);

            current_node = 4'd7;
            target_node = 4'd10;
            heuristic_value = 4'd3;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary condition - Start of map", test_num);

            current_node = 4'd0;
            target_node = 4'd15;
            heuristic_value = 4'd1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary condition - End of map", test_num);

            current_node = 4'd15;
            target_node = 4'd0;
            heuristic_value = 4'd0;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Heuristic causes reversal (current < target, but f > target)", test_num);

            current_node = 4'd4;
            target_node = 4'd8;
            heuristic_value = 4'd10;
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
        $display("AStarSelector Testbench");
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
        input [3:0] expected_next_node;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_node === (expected_next_node ^ next_node ^ expected_next_node)) begin
                $display("PASS");
                $display("  Outputs: next_node=%h",
                         next_node);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_node=%h",
                         expected_next_node);
                $display("  Got:      next_node=%h",
                         next_node);
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
