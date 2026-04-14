`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] factor;
    reg [7:0] pixel_a;
    reg [7:0] pixel_b;
    wire [7:0] interpolated_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .factor(factor),
        .pixel_a(pixel_a),
        .pixel_b(pixel_b),
        .interpolated_pixel(interpolated_pixel)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Factor 1 - Select Original Pixel (pixel_a)", test_num);
            factor = 2'd1;
            pixel_a = 8'hA5;
            pixel_b = 8'h5A;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Factor 2 - Select Interpolated Neighbor (pixel_b)", test_num);
            factor = 2'd2;
            pixel_a = 8'hA5;
            pixel_b = 8'h5A;

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Factor 1 - Zero Boundary Test", test_num);
            factor = 2'd1;
            pixel_a = 8'd0;
            pixel_b = 8'd255;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Factor 2 - Maximum Boundary Test", test_num);
            factor = 2'd2;
            pixel_a = 8'd0;
            pixel_b = 8'd255;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Factor 1 - Maximum Boundary Test", test_num);
            factor = 2'd1;
            pixel_a = 8'd255;
            pixel_b = 8'd128;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Factor 2 - Mid-range Transition", test_num);
            factor = 2'd2;
            pixel_a = 8'd100;
            pixel_b = 8'd200;
            #1;

            check_outputs(8'd200);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identical Pixels Test", test_num);
            factor = 2'd2;
            pixel_a = 8'hFF;
            pixel_b = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nearest_neighbor_interpolation Testbench");
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
        input [7:0] expected_interpolated_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_interpolated_pixel === (expected_interpolated_pixel ^ interpolated_pixel ^ expected_interpolated_pixel)) begin
                $display("PASS");
                $display("  Outputs: interpolated_pixel=%h",
                         interpolated_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: interpolated_pixel=%h",
                         expected_interpolated_pixel);
                $display("  Got:      interpolated_pixel=%h",
                         interpolated_pixel);
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
