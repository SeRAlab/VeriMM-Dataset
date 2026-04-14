`timescale 1ns/1ps

module graph_coloring_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] edges;
    wire [4:0] colors;

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
            test_num = test_num + 1;
            $display("Test Case 001: No edges (Graph with isolated nodes)");
            edges = 5'b00000;

            #1;


            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Single edge between Node 0 and Node 1");
            edges = 5'b00001;

            #1;


            check_outputs(5'b11110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Edges forming a complete path (0-1-2-3-4)");
            edges = 5'b01111;

            #1;


            check_outputs(5'b01010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Disjoint edges (0-1 and 2-3)");
            edges = 5'b00101;

            #1;


            check_outputs(5'b00110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Single edge in the middle (Node 2 and Node 3)");
            edges = 5'b00100;

            #1;


            check_outputs(5'b11000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Alternating edges (1-2 and 3-4)");
            edges = 5'b01010;

            #1;


            check_outputs(5'b01100);
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
        input [4:0] expected_colors;
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
