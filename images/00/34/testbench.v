`timescale 1ns/1ps

module prim_mst_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adj_matrix;
    wire [7:0] mst_edges;

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
        test_num = 1;
        $display("Test Case 001: Complete Graph K4");


        adj_matrix = 16'h7BDE;


        #1;



        check_outputs(8'h07);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Line Graph 0-1-2-3");


        adj_matrix = 16'h4A52;


        #1;



        check_outputs(8'h29);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Star Graph (Node 0 Hub)");


        adj_matrix = 16'h7888;


        #1;



        check_outputs(8'h07);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Star Graph (Node 1 Hub)");


        adj_matrix = 16'h4B44;


        #1;



        check_outputs(8'h19);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Square Cycle Graph");


        adj_matrix = 16'h5AA5;



        #1;




        check_outputs(8'h0D);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Empty Graph");
        adj_matrix = 16'h0000;

        #1;


        check_outputs(8'h00);
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
        input [7:0] expected_mst_edges;
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
