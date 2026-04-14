`timescale 1ns/1ps

module graph_coloring_tb;

    // Testbench signals (combinational circuit)
    reg [24:0] adjacency_matrix;
    wire can_color;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    graph_coloring dut (
        .adjacency_matrix(adjacency_matrix),
        .can_color(can_color)
    );
    task testcase001;

        begin
            test_num = 1;
            adjacency_matrix = 25'b00000_00000_00000_00000_00000;
            $display("Test %0d: Empty Graph", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            adjacency_matrix = 25'b01111_10111_11011_11101_11110;
            $display("Test %0d: Complete Graph K5", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            adjacency_matrix = 25'b01110_10110_11010_11100_00000;
            $display("Test %0d: Subgraph K4", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            adjacency_matrix = 25'b01001_10100_01010_00101_10010;
            $display("Test %0d: Cycle Graph C5", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            adjacency_matrix = 25'b01111_10000_10000_10000_10000;
            $display("Test %0d: Star Graph K1,4", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            adjacency_matrix = 25'b01100_10100_11000_00000_00000;
            $display("Test %0d: Triangle K3", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            adjacency_matrix = 25'b01011_10101_01011_10101_11110;
            $display("Test %0d: Wheel Graph W5", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            adjacency_matrix = 25'b01000_10100_01010_00101_00010;
            $display("Test %0d: Simple Path 0-1-2-3-4", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            adjacency_matrix = 25'b00000_00111_01011_01101_01110;
            $display("Test %0d: Subgraph K4 (shifted)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            adjacency_matrix = 25'b00111_00111_11000_11000_11000;
            $display("Test %0d: Bipartite Graph K2,3", test_num);
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
