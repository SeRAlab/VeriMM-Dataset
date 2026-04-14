`timescale 1ns/1ps

module floyd_warshall_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adj_matrix;
    wire [15:0] shortest_paths;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    floyd_warshall dut (
        .adj_matrix(adj_matrix),
        .shortest_paths(shortest_paths)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Empty Graph (No Edges)", test_num);
            adj_matrix = 16'h0000;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Complete Graph (All Edges)", test_num);
            adj_matrix = 16'hFFFF;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Line Graph (0->1, 1->2, 2->3)", test_num);




            adj_matrix = 16'h4210;





            #1;






            check_outputs(16'h7310);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Single Edge (0->1)", test_num);
            adj_matrix = 16'h4000;

            #1;


            check_outputs(16'h4000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Cycle (0->1->2->3->0)", test_num);




            adj_matrix = 16'h4218;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Star Graph (0 reaches all)", test_num);


            adj_matrix = 16'h7000;

            #1;


            check_outputs(16'h7000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Disconnected Components (0->1 and 2->3)", test_num);


            adj_matrix = 16'h4010;

            #1;


            check_outputs(16'h4010);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Reverse Line with Self-Loop (3->2->1->0, 3->3)", test_num);





            adj_matrix = 16'h0843;








            #1;









            check_outputs(16'h08CF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("floyd_warshall Testbench");
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
        input [15:0] expected_shortest_paths;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shortest_paths === (expected_shortest_paths ^ shortest_paths ^ expected_shortest_paths)) begin
                $display("PASS");
                $display("  Outputs: shortest_paths=%h",
                         shortest_paths);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shortest_paths=%h",
                         expected_shortest_paths);
                $display("  Got:      shortest_paths=%h",
                         shortest_paths);
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
