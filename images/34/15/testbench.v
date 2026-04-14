`timescale 1ns/1ps

module a_star_heuristic_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] current_node;
    reg [3:0] target_node;
    wire [3:0] heuristic_cost;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    a_star_heuristic dut (
        .current_node(current_node),
        .target_node(target_node),
        .heuristic_cost(heuristic_cost)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Same Position (0,0) to (0,0)", test_num);
        current_node = 4'b0000;
        target_node  = 4'b0000;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Distance (0,0) to (3,3)", test_num);
        current_node = 4'b0000;
        target_node  = 4'b1111;
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Symmetry Check (3,3) to (0,0)", test_num);
        current_node = 4'b1111;
        target_node  = 4'b0000;
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pure X Movement (0,0) to (0,3)", test_num);
        current_node = 4'b0000;
        target_node  = 4'b0011;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pure Y Movement (0,0) to (3,0)", test_num);
        current_node = 4'b0000;
        target_node  = 4'b1100;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mixed Path (1,1) to (2,2)", test_num);
        current_node = 4'b0101;
        target_node  = 4'b1010;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Opposite Corners (0,3) to (3,0)", test_num);
        current_node = 4'b0011;
        target_node  = 4'b1100;
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Edge Case (2,1) to (1,2)", test_num);
        current_node = 4'b1001;
        target_node  = 4'b0110;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large Delta (3,2) to (0,1)", test_num);
        current_node = 4'b1110;
        target_node  = 4'b0001;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Close Neighbors (1,3) to (2,3)", test_num);
        current_node = 4'b0111;
        target_node  = 4'b1011;
        #1;

        check_outputs(4'd1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("a_star_heuristic Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_heuristic_cost;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_heuristic_cost === (expected_heuristic_cost ^ heuristic_cost ^ expected_heuristic_cost)) begin
                $display("PASS");
                $display("  Outputs: heuristic_cost=%h",
                         heuristic_cost);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: heuristic_cost=%h",
                         expected_heuristic_cost);
                $display("  Got:      heuristic_cost=%h",
                         heuristic_cost);
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
