`timescale 1ns/1ps

module prim_mst_tb;

    // Testbench signals (combinational circuit)
    reg [24:0] adj_matrix;
    wire [24:0] mst_edges;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    prim_mst dut (
        .adj_matrix(adj_matrix),
        .mst_edges(mst_edges)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: Path Graph (0-1-2-3-4)");
            test_num = test_num + 1;


            adj_matrix = 25'h08A28A2;

            #1;


            check_outputs(25'h08A28A2);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Star Graph (Center 0)");
            test_num = test_num + 1;


            adj_matrix = 25'h010843E;

            #1;


            check_outputs(25'h010843E);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Cycle 0-1-2 and Disjoint Line 3-4");
            test_num = test_num + 1;


            adj_matrix = 25'h0880CE6;



            #1;




            check_outputs(25'h0880426);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Disconnected Components (0-1, 2-3, 4-Isolated)");
            test_num = test_num + 1;



            adj_matrix = 25'h0022022;

            #1;


            check_outputs(25'h0022022);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Complete Graph K5 (All Weights 1)");
            test_num = test_num + 1;


            adj_matrix = 25'h0FBEF7E;


            #1;



            check_outputs(25'h010843E);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("prim_mst Testbench");
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
        input [24:0] expected_mst_edges;
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
