`timescale 1ns/1ps

module monte_carlo_pi_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] num_points;
    reg [3:0] points_inside_circle;
    wire [7:0] pi_estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    monte_carlo_pi dut (
        .num_points(num_points),
        .points_inside_circle(points_inside_circle),
        .pi_estimate(pi_estimate)
    );
    task testcase001;

    begin
        $display("\nTest Case 001: Perfect Quarter Circle Ratio (3/4)");
        num_points = 4'd4;
        points_inside_circle = 4'd3;

        #1;


        check_outputs(8'h30);
    end
        endtask

    task testcase002;

    begin
        $display("\nTest Case 002: Maximum possible value (All points inside)");
        num_points = 4'd1;
        points_inside_circle = 4'd1;

        #1;


        check_outputs(8'h40);
    end
        endtask

    task testcase003;

    begin
        $display("\nTest Case 003: Common Monte Carlo approximation (8/10)");
        num_points = 4'd10;
        points_inside_circle = 4'd8;

        #1;


        check_outputs(8'h33);
    end
        endtask

    task testcase004;

    begin
        $display("\nTest Case 004: Minimum possible value (Zero points inside)");
        num_points = 4'd5;
        points_inside_circle = 4'd0;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        $display("\nTest Case 005: High resolution sample (11/15)");
        num_points = 4'd15;
        points_inside_circle = 4'd11;

        #1;


        check_outputs(8'h2E);
    end
        endtask

    task testcase006;

    begin
        $display("\nTest Case 006: Small ratio (2/8)");
        num_points = 4'd8;
        points_inside_circle = 4'd2;

        #1;


        check_outputs(8'h10);
    end
        endtask

    task testcase007;

    begin
        $display("\nTest Case 007: Standard quarter-pi estimate (12/15)");
        num_points = 4'd15;
        points_inside_circle = 4'd12;

        #1;


        check_outputs(8'h33);
    end
        endtask

    task testcase008;

    begin
        $display("\nTest Case 008: Edge case - single point outside");
        num_points = 4'd2;
        points_inside_circle = 4'd0;

        #1;


        check_outputs(8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("monte_carlo_pi Testbench");
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
        input [7:0] expected_pi_estimate;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pi_estimate === (expected_pi_estimate ^ pi_estimate ^ expected_pi_estimate)) begin
                $display("PASS");
                $display("  Outputs: pi_estimate=%h",
                         pi_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pi_estimate=%h",
                         expected_pi_estimate);
                $display("  Got:      pi_estimate=%h",
                         pi_estimate);
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
