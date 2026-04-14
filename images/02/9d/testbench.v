`timescale 1ns/1ps

module prim_mst_tb;

    // Testbench signals (combinational circuit)
    reg [124:0] adj_matrix;
    wire [63:0] mst_edges;

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
            $display("\nRunning Testcase 001: Chain Graph (0-1-2-3-4)");
            test_num = 1;
            adj_matrix = {

                5'd0, 5'd1, 5'd0, 5'd0, 5'd0,

                5'd1, 5'd0, 5'd1, 5'd0, 5'd0,

                5'd0, 5'd1, 5'd0, 5'd1, 5'd0,

                5'd0, 5'd0, 5'd1, 5'd0, 5'd1,

                5'd0, 5'd0, 5'd0, 5'd1, 5'd0
            };


            #1;



            check_outputs(64'h0304_0203_0102_0001);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Star Graph (0 is center)");
            test_num = 2;
            adj_matrix = {

                5'd0, 5'd0, 5'd0, 5'd0, 5'd5,

                5'd0, 5'd0, 5'd0, 5'd0, 5'd5,

                5'd0, 5'd0, 5'd0, 5'd0, 5'd5,

                5'd0, 5'd0, 5'd0, 5'd0, 5'd5,

                5'd5, 5'd5, 5'd5, 5'd5, 5'd0
            };

            #1;


            check_outputs(64'h0004_0003_0002_0001);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Star Graph (2 is center)");
            test_num = 3;
            adj_matrix = {

                5'd0, 5'd0, 5'd7, 5'd0, 5'd0,

                5'd0, 5'd0, 5'd7, 5'd0, 5'd0,

                5'd7, 5'd7, 5'd0, 5'd7, 5'd7,

                5'd0, 5'd0, 5'd7, 5'd0, 5'd0,

                5'd0, 5'd0, 5'd7, 5'd0, 5'd0
            };

            #1;


            check_outputs(64'h0204_0203_0201_0002);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Complex Graph");
            test_num = 4;
            adj_matrix = {

                5'd0, 5'd1, 5'd1, 5'd0, 5'd0,

                5'd1, 5'd0, 5'd0, 5'd0, 5'd2,

                5'd1, 5'd0, 5'd0, 5'd3, 5'd0,

                5'd0, 5'd0, 5'd3, 5'd0, 5'd10,

                5'd0, 5'd2, 5'd0, 5'd10, 5'd0
            };





            #1;






            check_outputs(64'h0201_0402_0304_0003);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Fully Connected K5 (All weights 1)");
            test_num = 5;
            adj_matrix = {
                {5'd0, 5'd1, 5'd1, 5'd1, 5'd1},
                {5'd1, 5'd0, 5'd1, 5'd1, 5'd1},
                {5'd1, 5'd1, 5'd0, 5'd1, 5'd1},
                {5'd1, 5'd1, 5'd1, 5'd0, 5'd1},
                {5'd1, 5'd1, 5'd1, 5'd1, 5'd0}
            };

            #1;


            check_outputs(64'h0004_0003_0002_0001);
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
        input [63:0] expected_mst_edges;
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
