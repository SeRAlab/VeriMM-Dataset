`timescale 1ns/1ps

module hough_transform_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_val;
    wire [15:0] rho;
    wire [7:0] theta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hough_transform dut (
        .pixel_val(pixel_val),
        .rho(rho),
        .theta(theta)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Background/Null Pixel", test_num);

        pixel_val = 8'h00;

        #1;


        check_outputs(16'h0000, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum Active Pixel Value", test_num);

        pixel_val = 8'h01;


        #1;



        check_outputs(16'h0000, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-range Pixel Input", test_num);

        pixel_val = 8'h7F;

        #1;


        check_outputs(16'h0040, 8'h2D);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: High-range Coordinate/Intensity", test_num);

        pixel_val = 8'hC0;

        #1;


        check_outputs(16'h0080, 8'h5A);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Pixel Input", test_num);

        pixel_val = 8'hFF;

        #1;


        check_outputs(16'h00B4, 8'hB4);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hough_transform Testbench");
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
        input [15:0] expected_rho;
        input [7:0] expected_theta;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rho === (expected_rho ^ rho ^ expected_rho) &&
                expected_theta === (expected_theta ^ theta ^ expected_theta)) begin
                $display("PASS");
                $display("  Outputs: rho=%h, theta=%h",
                         rho, theta);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rho=%h, theta=%h",
                         expected_rho, expected_theta);
                $display("  Got:      rho=%h, theta=%h",
                         rho, theta);
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
