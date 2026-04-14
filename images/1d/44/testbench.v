`timescale 1ns/1ps

module monte_carlo_pi_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] total_points;
    reg [39:0] x;
    reg [39:0] y;
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
            test_num = test_num + 1;
            $display("Testcase %0d: Point at origin (0,0) - Inside circle", test_num);
            total_points = 32'd1;
            x = 40'h00_0000_0000;
            y = 40'h00_0000_0000;

            #1;


            check_outputs(32'd4);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Point at (1,1) - Outside circle", test_num);
            total_points = 32'd1;
            x = 40'hFF_FFFF_FFFF;
            y = 40'hFF_FFFF_FFFF;

            #1;


            check_outputs(32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Point (0.5, 0.5) - Inside, total_points=2", test_num);
            total_points = 32'd2;
            x = 40'h80_0000_0000;
            y = 40'h80_0000_0000;


            #1;



            check_outputs(32'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary point (0.6, 0.8) - Inside circle", test_num);
            total_points = 32'd1;
            x = 40'h99_9999_999A;
            y = 40'hCC_CCCC_CCCD;


            #1;



            check_outputs(32'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Point (0.8, 0.8) - Outside circle", test_num);
            total_points = 32'd4;
            x = 40'hCC_CCCC_CCCD;
            y = 40'hCC_CCCC_CCCD;


            #1;



            check_outputs(32'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small coordinate (0.1, 0.1) - Inside, total_points=4", test_num);
            total_points = 32'd4;
            x = 40'h19_9999_999A;
            y = 40'h19_9999_999A;


            #1;



            check_outputs(32'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large total_points, Point Inside", test_num);
            total_points = 32'd100;
            x = 40'h40_0000_0000;
            y = 40'h40_0000_0000;

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
