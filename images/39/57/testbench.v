`timescale 1ns/1ps

module graph_coloring_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adj_matrix;
    reg [3:0] vertices;
    wire [3:0] colors;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    graph_coloring dut (
        .adj_matrix(adj_matrix),
        .vertices(vertices),
        .colors(colors)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        vertices = 4'd4;
        adj_matrix = 16'h0000;
        $display("Test %0d: Empty Graph (All vertices independent)", test_num);
        #1;

        check_outputs(8'b00_00_00_00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        vertices = 4'd4;
        adj_matrix = 16'h7BDE;
        $display("Test %0d: Complete Graph K4 (Requires 4 colors)", test_num);
        #1;

        check_outputs(8'b11_10_01_00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        vertices = 4'd4;
        adj_matrix = 16'h4A52;
        $display("Test %0d: Linear Chain 0-1-2-3 (Bipartite)", test_num);
        #1;

        check_outputs(8'b01_00_01_00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        vertices = 4'd4;
        adj_matrix = 16'h7888;
        $display("Test %0d: Star Graph (Center V0)", test_num);
        #1;

        check_outputs(8'b01_01_01_00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        vertices = 4'd4;
        adj_matrix = 16'h5A5A;
        $display("Test %0d: Cycle Graph C4", test_num);
        #1;

        check_outputs(8'b01_00_01_00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        vertices = 4'd4;
        adj_matrix = 16'h4824;
        $display("Test %0d: Disconnected Edges (0-1 and 2-3)", test_num);
        #1;

        check_outputs(8'b01_00_01_00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        vertices = 4'd4;
        adj_matrix = 16'h6B40;
        $display("Test %0d: Triangle (0-1-2) and Isolated Vertex 3", test_num);
        #1;

        check_outputs(8'b00_10_01_00);
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
