`timescale 1ns/1ps

module dijkstra_shortest_path_tb;

    // Testbench signals (combinational circuit)
    reg [24:0] adj_matrix;
    reg [2:0] start_node;
    wire [4:0] distances;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dijkstra_shortest_path dut (
        .adj_matrix(adj_matrix),
        .start_node(start_node),
        .distances(distances)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: No edges - Only start node reachable", test_num);
            adj_matrix = 25'b0;
            start_node = 3'd0;

            #1;


            check_outputs(5'b00001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Linear Path 0->1->2->3->4", test_num);


            adj_matrix = 25'b00000_10000_01000_00100_00010;
            start_node = 3'd0;

            #1;


            check_outputs(5'b11111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Linear Path start from middle (node 2)", test_num);

            adj_matrix = 25'b00000_10000_01000_00100_00010;
            start_node = 3'd2;

            #1;


            check_outputs(5'b11100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Disconnected Components", test_num);


            adj_matrix = 25'b00000_10000_01000_00000_00010;
            start_node = 3'd0;

            #1;


            check_outputs(5'b00011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Cyclic Graph 0->1->0", test_num);

            adj_matrix = 25'b00000_00000_00000_00001_00010;
            start_node = 3'd1;

            #1;


            check_outputs(5'b00011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Star Graph (Center 2 connects to all)", test_num);

            adj_matrix = 25'b00000_00000_11111_00000_00000;
            start_node = 3'd2;

            #1;


            check_outputs(5'b11111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Star Graph (Leaf start node)", test_num);

            adj_matrix = 25'b00000_00000_11111_00000_00000;
            start_node = 3'd0;

            #1;


            check_outputs(5'b00001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Complex Jump 0->2, 2->4, 4->1", test_num);

            adj_matrix = 25'b00010_00000_10000_00000_00100;
            start_node = 3'd0;

            #1;


            check_outputs(5'b10111);
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
        testcase007();
        testcase008();
        
        
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
        input [4:0] expected_distances;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_distances === (expected_distances ^ distances ^ expected_distances)) begin
                $display("PASS");
                $display("  Outputs: distances=%h",
                         distances);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: distances=%h",
                         expected_distances);
                $display("  Got:      distances=%h",
                         distances);
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
