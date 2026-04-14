`timescale 1ns/1ps

module graph_coloring_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adj_matrix;
    wire can_color;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    graph_coloring dut (
        .adj_matrix(adj_matrix),
        .can_color(can_color)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Empty Graph (No edges)", test_num);
        adj_matrix = 16'h0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Path Graph P4 (0-1-2-3)", test_num);


        adj_matrix = 16'h4A52;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Triangle Graph C3 (0-1-2) with isolated node 3", test_num);


        adj_matrix = 16'h0656;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Square Graph C4 (0-1-2-3-0)", test_num);


        adj_matrix = 16'h5A5A;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Star Graph (Center 0 connected to 1,2,3)", test_num);


        adj_matrix = 16'h111E;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Complete Graph K4", test_num);


        adj_matrix = 16'h7BDE;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Graph with a Self-loop (Node 2)", test_num);


        adj_matrix = 16'h0400;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Disconnected Bipartite Components (0-1) and (2-3)", test_num);


        adj_matrix = 16'h4812;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Triangle on nodes (1,2,3)", test_num);


        adj_matrix = 16'h6AC0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Edge (0-3)", test_num);


        adj_matrix = 16'h1008;
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("graph_coloring Testbench");
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
        input expected_can_color;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_can_color === (expected_can_color ^ can_color ^ expected_can_color)) begin
                $display("PASS");
                $display("  Outputs: can_color=%b",
                         can_color);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: can_color=%b",
                         expected_can_color);
                $display("  Got:      can_color=%b",
                         can_color);
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
