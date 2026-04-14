`timescale 1ns/1ps

module dijkstra_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adj_matrix;
    wire [3:0] dist;
    wire [3:0] visited;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dijkstra dut (
        .adj_matrix(adj_matrix),
        .dist(dist),
        .visited(visited)
    );
    task testcase001;

        begin
            test_num = 1;
            adj_matrix = 16'h0000;
            $display("\nTestcase %0d: Empty Graph (No edges)", test_num);
            #1;

            check_outputs(4'h1, 4'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            adj_matrix = 16'h0002;
            $display("\nTestcase %0d: Direct connection 0->1", test_num);
            #1;

            check_outputs(4'h3, 4'h3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            adj_matrix = 16'h0042;
            $display("\nTestcase %0d: Linear chain 0->1->2", test_num);
            #1;

            check_outputs(4'h7, 4'h7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            adj_matrix = 16'h0842;
            $display("\nTestcase %0d: Full linear chain 0->1->2->3", test_num);
            #1;

            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            adj_matrix = 16'h000E;
            $display("\nTestcase %0d: Star topology (0 connects to 1, 2, 3)", test_num);
            #1;

            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            adj_matrix = 16'h0804;
            $display("\nTestcase %0d: Node 1 isolated (0->2->3)", test_num);
            #1;

            check_outputs(4'hD, 4'hD);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            adj_matrix = 16'h0840;
            $display("\nTestcase %0d: No outgoing edges from Node 0", test_num);
            #1;

            check_outputs(4'h1, 4'h1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            adj_matrix = 16'h4218;
            $display("\nTestcase %0d: Circular path 0->3->2->1", test_num);
            #1;

            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            adj_matrix = 16'h0886;
            $display("\nTestcase %0d: Multiple paths to Node 3", test_num);
            #1;

            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            adj_matrix = 16'h0033;
            $display("\nTestcase %0d: Self-loops (0->0, 0->1, 1->1)", test_num);
            #1;

            check_outputs(4'h3, 4'h3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dijkstra Testbench");
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
        input [3:0] expected_dist;
        input [3:0] expected_visited;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dist === (expected_dist ^ dist ^ expected_dist) &&
                expected_visited === (expected_visited ^ visited ^ expected_visited)) begin
                $display("PASS");
                $display("  Outputs: dist=%h, visited=%h",
                         dist, visited);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dist=%h, visited=%h",
                         expected_dist, expected_visited);
                $display("  Got:      dist=%h, visited=%h",
                         dist, visited);
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
