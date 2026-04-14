`timescale 1ns/1ps

module Prim_MST_tb;

    // Testbench signals (combinational circuit)
    reg [24:0] adjacency_matrix;
    wire [19:0] mst_edges;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Prim_MST dut (
        .adjacency_matrix(adjacency_matrix),
        .mst_edges(mst_edges)
    );
    task testcase001;

        begin
            $display("Test Case 001: Line Graph (0-1-2-3-4)");
            test_num = test_num + 1;



            adjacency_matrix = 25'b01000_10100_01010_00101_00010;


            #1;



            check_outputs(20'h32100);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Star Graph (Center at 0)");
            test_num = test_num + 1;


            adjacency_matrix = 25'b00001_00001_00001_00001_11110;


            #1;



            check_outputs(20'h00000);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Star Graph (Center at 2)");
            test_num = test_num + 1;


            adjacency_matrix = 25'b00100_00100_11011_00100_00100;



            #1;




            check_outputs(20'h22020);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Fully Connected Graph");
            test_num = test_num + 1;

            adjacency_matrix = 25'b01111_10111_11011_11101_11110;


            #1;



            check_outputs(20'h00000);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Cycle with Branch");
            test_num = test_num + 1;


            adjacency_matrix = 25'b01001_10100_01011_01010_10110;


            #1;



            check_outputs(20'h02000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Prim_MST Testbench");
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
        input [19:0] expected_mst_edges;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mst_edges === (expected_mst_edges ^ mst_edges ^ expected_mst_edges)) begin
                $display("PASS");
                $display("  Outputs: mst_edges=%h",
                         mst_edges);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mst_edges=%h",
                         expected_mst_edges);
                $display("  Got:      mst_edges=%h",
                         mst_edges);
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
