`timescale 1ns/1ps

module Dijkstra_tb;

    // Testbench signals (combinational circuit)
    reg [24:0] adj_matrix;
    reg [2:0] src;
    wire [4:0] dist;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Dijkstra dut (
        .adj_matrix(adj_matrix),
        .src(src),
        .dist(dist)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Isolated Vertex (Source 0)", test_num);
        adj_matrix = 25'b0;
        src = 3'd0;
        #1;

        check_outputs(5'b00001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Linear Chain 0->1->2->3->4", test_num);
        adj_matrix = 25'h082082;
        src = 3'd0;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Disconnected Components (Start at 0)", test_num);
        adj_matrix = 25'h080082;
        src = 3'd0;
        #1;

        check_outputs(5'b00111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Disconnected Components (Start at 3)", test_num);
        adj_matrix = 25'h080082;
        src = 3'd3;
        #1;

        check_outputs(5'b11000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Star Graph Outward (Start at 2)", test_num);
        adj_matrix = 25'h006C00;
        src = 3'd2;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Star Graph Inward (Start at 0)", test_num);
        adj_matrix = 25'h006C00;
        src = 3'd0;
        #1;

        check_outputs(5'b00001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Cyclic Graph 0->1->2->0", test_num);
        adj_matrix = 25'h000482;
        src = 3'd1;
        #1;

        check_outputs(5'b00111);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Dijkstra Testbench");
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
        input [4:0] expected_dist;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dist === (expected_dist ^ dist ^ expected_dist)) begin
                $display("PASS");
                $display("  Outputs: dist=%h",
                         dist);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dist=%h",
                         expected_dist);
                $display("  Got:      dist=%h",
                         dist);
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
