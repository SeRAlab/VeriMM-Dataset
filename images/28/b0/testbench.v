`timescale 1ns/1ps

module graph_coloring_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] edges;
    wire [3:0] colors;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    graph_coloring dut (
        .edges(edges),
        .colors(colors)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Empty Graph (No Edges)");
        edges = 16'h0000;

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Single Edge (Node 0 - Node 1)");

        edges = 16'h0012;

        #1;


        check_outputs(4'b0010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Star Graph (Node 0 connected to 1, 2, 3)");

        edges = 16'h111E;

        #1;


        check_outputs(4'b1110);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Linear Chain (0-1-2-3)");

        edges = 16'h4A52;

        #1;


        check_outputs(4'b1010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Disconnected Components (0-1 and 2-3)");

        edges = 16'h4812;

        #1;


        check_outputs(4'b1010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Complete Bipartite Graph K2,2 ({0,1} connected to {2,3})");

        edges = 16'h33CC;

        #1;


        check_outputs(4'b1100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Ring Graph (0-1-2-3-0)");

        edges = 16'h5A5A;

        #1;


        check_outputs(4'b1010);
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
        input [3:0] expected_colors;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_colors === (expected_colors ^ colors ^ expected_colors)) begin
                $display("PASS");
                $display("  Outputs: colors=%h",
                         colors);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: colors=%h",
                         expected_colors);
                $display("  Got:      colors=%h",
                         colors);
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
