`timescale 1ns/1ps

module hough_transform_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel;
    wire [7:0] rho;
    wire [7:0] theta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hough_transform dut (
        .pixel(pixel),
        .rho(rho),
        .theta(theta)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pixel at Origin (0,0)", test_num);


            pixel = 8'h00;


            #1;



            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pixel at (7,0) - X-axis Boundary", test_num);

            pixel = 8'h70;


            #1;



            check_outputs(8'h07, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pixel at (0,7) - Y-axis Boundary", test_num);

            pixel = 8'h07;


            #1;



            check_outputs(8'h07, 8'h5A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pixel at (7,7) - Maximum Boundary", test_num);

            pixel = 8'h77;


            #1;



            check_outputs(8'h0A, 8'h2D);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pixel at (4,4) - Center of 8x8 Grid", test_num);

            pixel = 8'h44;

            #1;


            check_outputs(8'h05, 8'h2D);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input Zero Pixel / Background", test_num);

            pixel = 8'hFF;
            #1;

            check_outputs(8'h00, 8'h00);
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
        input [7:0] expected_rho;
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
