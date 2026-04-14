`timescale 1ns/1ps

module dijkstra_shortest_path_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] adjacency_matrix;
    wire [3:0] distances;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dijkstra_shortest_path dut (
        .adjacency_matrix(adjacency_matrix),
        .distances(distances)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All disconnected (No edges)", test_num);

            adjacency_matrix = 9'b000_000_000;

            #1;


            check_outputs(4'hf);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Direct edges to all nodes", test_num);

            adjacency_matrix = 9'b000_000_110;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Chain 0 -> 1 -> 2", test_num);

            adjacency_matrix = 9'b000_100_010;

            #1;


            check_outputs(4'h9);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Chain 0 -> 2 -> 1", test_num);

            adjacency_matrix = 9'b010_000_100;

            #1;


            check_outputs(4'h6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Redundant paths (direct is shorter)", test_num);


            adjacency_matrix = 9'b000_100_110;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only Node 1 reachable", test_num);

            adjacency_matrix = 9'b000_000_010;

            #1;


            check_outputs(4'hd);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only Node 2 reachable", test_num);

            adjacency_matrix = 9'b000_000_100;

            #1;


            check_outputs(4'h7);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full mesh with cycles", test_num);

            adjacency_matrix = 9'b111_111_111;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Node 2 reachable only through 1", test_num);

            adjacency_matrix = 9'b001_100_010;

            #1;


            check_outputs(4'h9);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Weights ignored on self-loops", test_num);

            adjacency_matrix = 9'b100_010_001;

            #1;


            check_outputs(4'hf);
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
        input [3:0] expected_distances;
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
