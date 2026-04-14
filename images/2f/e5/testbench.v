`timescale 1ns/1ps

module FloydWarshall_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] weight_matrix;
    wire [15:0] shortest_paths;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    FloydWarshall dut (
        .weight_matrix(weight_matrix),
        .shortest_paths(shortest_paths)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No Edges", test_num);
            weight_matrix = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fully Connected Graph", test_num);
            weight_matrix = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Linear Chain 0->1->2->3", test_num);
            weight_matrix = 16'h0842;
            #1;

            check_outputs(16'h08CE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Disconnected Components", test_num);
            weight_matrix = 16'h4812;
            #1;

            check_outputs(16'hCC33);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Star Graph (Center 0)", test_num);
            weight_matrix = 16'h000E;
            #1;

            check_outputs(16'h000E);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Cyclic Subgraph (0-1-2) + Isolated 3", test_num);
            weight_matrix = 16'h0142;

            #1;


            check_outputs(16'h0777);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("FloydWarshall Testbench");
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
