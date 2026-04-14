`timescale 1ns/1ps

module floyd_warshall_tb;

    // Testbench signals (combinational circuit)
    reg [71:0] weight_matrix;
    wire [71:0] shortest_paths;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    floyd_warshall dut (
        .weight_matrix(weight_matrix),
        .shortest_paths(shortest_paths)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple Directed Shortcut (0->1->2)", test_num);

            weight_matrix = {8'h00, 8'h02, 8'h0A, 8'hFF, 8'h00, 8'h03, 8'hFF, 8'hFF, 8'h00};

            #1;


            check_outputs({8'h00, 8'h02, 8'h05, 8'hFF, 8'h00, 8'h03, 8'hFF, 8'hFF, 8'h00});
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shortcuts through Node 2", test_num);

            weight_matrix = {8'h00, 8'h0A, 8'h01, 8'h0A, 8'h00, 8'h01, 8'h01, 8'h01, 8'h00};

            #1;


            check_outputs({8'h00, 8'h02, 8'h01, 8'h02, 8'h00, 8'h01, 8'h01, 8'h01, 8'h00});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Disconnected Components", test_num);

            weight_matrix = {8'h00, 8'h05, 8'hFF, 8'h05, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'h00};

            #1;


            check_outputs({8'h00, 8'h05, 8'hFF, 8'h05, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'h00});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Path through Node 0", test_num);

            weight_matrix = {8'h00, 8'hFF, 8'h06, 8'h04, 8'h00, 8'h14, 8'hFF, 8'hFF, 8'h00};

            #1;


            check_outputs({8'h00, 8'hFF, 8'h06, 8'h04, 8'h00, 8'h0A, 8'hFF, 8'hFF, 8'h00});
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Isolated Nodes", test_num);

            weight_matrix = {8'h00, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'h00};

            #1;


            check_outputs({8'h00, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'h00});
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
        input [71:0] expected_shortest_paths;
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
