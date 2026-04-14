`timescale 1ns/1ps

module graph_coloring_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] adj_matrix;
    reg [2:0] num_colors;
    wire is_colorable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    graph_coloring dut (
        .adj_matrix(adj_matrix),
        .num_colors(num_colors),
        .is_colorable(is_colorable)
    );
    task testcase001;

    begin
        $display("Testcase 001: Empty Graph, 1 Color");
        test_num = 1;
        adj_matrix = 8'h00;
        num_colors = 3'd1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Single Edge, 1 Color");
        test_num = 2;
        adj_matrix = 8'h01;
        num_colors = 3'd1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Single Edge, 2 Colors");
        test_num = 3;
        adj_matrix = 8'h01;
        num_colors = 3'd2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Triangle Graph (K3), 2 Colors");
        test_num = 4;
        adj_matrix = 8'h07;
        num_colors = 3'd2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Triangle Graph (K3), 3 Colors");
        test_num = 5;
        adj_matrix = 8'h07;
        num_colors = 3'd3;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Square Graph (C4), 2 Colors");
        test_num = 6;
        adj_matrix = 8'h2D;
        num_colors = 3'd2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Star Graph, 2 Colors");
        test_num = 7;
        adj_matrix = 8'h13;
        num_colors = 3'd2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Complete Graph (K4), 3 Colors");
        test_num = 8;
        adj_matrix = 8'h3F;
        num_colors = 3'd3;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Complete Graph (K4), 4 Colors");
        test_num = 9;
        adj_matrix = 8'h3F;
        num_colors = 3'd4;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Disconnected Edges, 2 Colors");
        test_num = 10;
        adj_matrix = 8'h21;
        num_colors = 3'd2;
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
        input expected_is_colorable;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_colorable === (expected_is_colorable ^ is_colorable ^ expected_is_colorable)) begin
                $display("PASS");
                $display("  Outputs: is_colorable=%b",
                         is_colorable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_colorable=%b",
                         expected_is_colorable);
                $display("  Got:      is_colorable=%b",
                         is_colorable);
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
