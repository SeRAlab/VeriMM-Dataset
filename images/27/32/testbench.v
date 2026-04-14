`timescale 1ns/1ps

module dijkstra_shortest_path_tb;

    // Testbench signals (combinational circuit)
    reg [24:0] adj_matrix;
    reg [2:0] source_node;
    wire [4:0] shortest_distances;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dijkstra_shortest_path dut (
        .adj_matrix(adj_matrix),
        .source_node(source_node),
        .shortest_distances(shortest_distances)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Isolated Node", test_num);
            adj_matrix = 25'b0;
            source_node = 3'd0;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Linear Chain (0->1->2->3->4)", test_num);
            adj_matrix = (1<<1) | (1<<7) | (1<<13) | (1<<19);
            source_node = 3'd0;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Star Graph (2->0, 2->4)", test_num);
            adj_matrix = (1<<10) | (1<<14);
            source_node = 3'd2;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Disconnected Components", test_num);
            adj_matrix = (1<<16) | (1<<5) | (1<<22);
            source_node = 3'd3;
            #1;

            check_outputs(5'b01011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Cyclic Graph (1<->2)", test_num);
            adj_matrix = (1<<7) | (1<<11);
            source_node = 3'd1;
            #1;

            check_outputs(5'b00110);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Complete Graph", test_num);
            adj_matrix = 25'h1FFFFFF;
            source_node = 3'd4;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dijkstra_shortest_path Testbench");
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
        input [4:0] expected_shortest_distances;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shortest_distances === (expected_shortest_distances ^ shortest_distances ^ expected_shortest_distances)) begin
                $display("PASS");
                $display("  Outputs: shortest_distances=%h",
                         shortest_distances);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shortest_distances=%h",
                         expected_shortest_distances);
                $display("  Got:      shortest_distances=%h",
                         shortest_distances);
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
