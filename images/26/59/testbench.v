`timescale 1ns/1ps

module floyd_warshall_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] distance_in;
    wire [15:0] distance_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    floyd_warshall dut (
        .distance_in(distance_in),
        .distance_out(distance_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Direct Paths", test_num);
            distance_in = 16'h0340;
            #1;

            check_outputs(16'h0340);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Path Improvement (Cycle)", test_num);
            distance_in = 16'h8228;
            #1;

            check_outputs(16'h4224);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Disconnected Nodes (Infinity)", test_num);
            distance_in = 16'h0FF0;
            #1;

            check_outputs(16'h0FF0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros", test_num);
            distance_in = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asymmetric Graph", test_num);
            distance_in = 16'h0710;
            #1;

            check_outputs(16'h0710);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sub-optimal Self-loops", test_num);
            distance_in = 16'hF11F;
            #1;

            check_outputs(16'h2112);
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
        input [15:0] expected_distance_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_distance_out === (expected_distance_out ^ distance_out ^ expected_distance_out)) begin
                $display("PASS");
                $display("  Outputs: distance_out=%h",
                         distance_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: distance_out=%h",
                         expected_distance_out);
                $display("  Got:      distance_out=%h",
                         distance_out);
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
