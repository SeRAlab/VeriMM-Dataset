`timescale 1ns/1ps

module monte_carlo_pi_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] total_points;
    reg [7:0] x;
    reg [7:0] y;
    wire [31:0] pi_estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    monte_carlo_pi dut (
        .total_points(total_points),
        .x(x),
        .y(y),
        .pi_estimate(pi_estimate)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Point at Origin (0,0)", test_num);
            total_points = 8'd1;
            x = 8'd0;
            y = 8'd0;
            #1;

            check_outputs(32'd4);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Point at Far Corner (255,255)", test_num);
            total_points = 8'd1;
            x = 8'd255;
            y = 8'd255;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Point on Boundary (255,0)", test_num);
            total_points = 8'd1;
            x = 8'd255;
            y = 8'd0;
            #1;

            check_outputs(32'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Mid-range Inside Point (128,128)", test_num);
            total_points = 8'd1;
            x = 8'd128;
            y = 8'd128;
            #1;

            check_outputs(32'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Mid-range Outside Point (200,200)", test_num);
            total_points = 8'd1;
            x = 8'd200;
            y = 8'd200;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Scaled Ratio (Total=2, Point Inside)", test_num);
            total_points = 8'd2;
            x = 8'd0;
            y = 8'd0;
            #1;

            check_outputs(32'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Scaled Ratio (Total=4, Point Inside)", test_num);
            total_points = 8'd4;
            x = 8'd0;
            y = 8'd0;
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: Point Outside with High Total Count", test_num);
            total_points = 8'd10;
            x = 8'd255;
            y = 8'd255;
            #1;

            check_outputs(32'd0);
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
        input [31:0] expected_pi_estimate;
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
