`timescale 1ns/1ps

module bellman_ford_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] edges;
    reg [4:0] source;
    reg [4:0] weights;
    wire [4:0] distances;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bellman_ford dut (
        .edges(edges),
        .source(source),
        .weights(weights),
        .distances(distances)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Source node 0, target edge node 1, weight 5");
            source = 5'd0;
            edges = 5'd1;
            weights = 5'd5;

            #1;


            check_outputs(5'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Source node 1, target edge node 2, weight 15");
            source = 5'd1;
            edges = 5'd2;
            weights = 5'd15;

            #1;


            check_outputs(5'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Zero weight edge");
            source = 5'd0;
            edges = 5'd3;
            weights = 5'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Maximum possible weight value");
            source = 5'd2;
            edges = 5'd4;
            weights = 5'd31;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Source is target node");
            source = 5'd10;
            edges = 5'd10;
            weights = 5'd20;

            #1;


            check_outputs(5'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Small weight path");
            source = 5'd5;
            edges = 5'd6;
            weights = 5'd1;
            #1;

            check_outputs(5'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bellman_ford Testbench");
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
