`timescale 1ns/1ps

module floyd_warshall_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adj_matrix;
    wire [15:0] shortest_path;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    floyd_warshall dut (
        .adj_matrix(adj_matrix),
        .shortest_path(shortest_path)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Empty Graph (No edges)", test_num);
            adj_matrix = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity Matrix (Self-loops only)", test_num);

            adj_matrix = 16'h8421;
            #1;

            check_outputs(16'h8421);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Transitive Path (0->1, 1->2)", test_num);

            adj_matrix = 16'h4200;

            #1;


            check_outputs(16'h6200);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Chain (0->1->2->3)", test_num);

            adj_matrix = 16'h4210;

            #1;


            check_outputs(16'h7310);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Cycle (0->1, 1->0)", test_num);

            adj_matrix = 16'h4800;

            #1;


            check_outputs(16'hCC00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Hamiltonian Cycle (0->1->2->3->0)", test_num);

            adj_matrix = 16'h4218;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Out-Star Graph (Center 0)", test_num);

            adj_matrix = 16'h7000;
            #1;

            check_outputs(16'h7000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: In-Star Graph (Sink 0)", test_num);

            adj_matrix = 16'h0888;
            #1;

            check_outputs(16'h0888);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two Disconnected Cycles (0-1 and 2-3)", test_num);

            adj_matrix = 16'h4812;

            #1;


            check_outputs(16'hCC33);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex Graph (Cycle with branch)", test_num);





            adj_matrix = 16'h4290;


            #1;



            check_outputs(16'hFFF0);
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
        input [15:0] expected_shortest_path;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shortest_path === (expected_shortest_path ^ shortest_path ^ expected_shortest_path)) begin
                $display("PASS");
                $display("  Outputs: shortest_path=%h",
                         shortest_path);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shortest_path=%h",
                         expected_shortest_path);
                $display("  Got:      shortest_path=%h",
                         shortest_path);
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
