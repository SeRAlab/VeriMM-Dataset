`timescale 1ns/1ps

module hough_transform_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] binary_image;
    wire [5:0] r;
    wire [3:0] theta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hough_transform dut (
        .binary_image(binary_image),
        .r(r),
        .theta(theta)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vertical Line at x=2", test_num);

            binary_image = 64'h0404040404040404;
            #1;

            check_outputs(6'd2, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Horizontal Line at y=4", test_num);

            binary_image = 64'h000000FF00000000;
            #1;

            check_outputs(6'd4, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Diagonal Line y=x", test_num);

            binary_image = 64'h8040201008040201;
            #1;

            check_outputs(6'd0, 4'd12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Anti-Diagonal Line x+y=7", test_num);

            binary_image = 64'h0102040810204080;
            #1;

            check_outputs(6'd5, 4'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vertical Line at x=7", test_num);

            binary_image = 64'h8080808080808080;
            #1;

            check_outputs(6'd7, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Horizontal Line at y=0", test_num);

            binary_image = 64'h00000000000000FF;
            #1;

            check_outputs(6'd0, 4'd8);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Empty Image", test_num);
            binary_image = 64'h0000000000000000;
            #1;

            check_outputs(6'd0, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Pixels Active", test_num);
            binary_image = 64'hFFFFFFFFFFFFFFFF;

            #1;


            check_outputs(6'd0, 4'd0);
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
        input [5:0] expected_r;
        input [3:0] expected_theta;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_r === (expected_r ^ r ^ expected_r) &&
                expected_theta === (expected_theta ^ theta ^ expected_theta)) begin
                $display("PASS");
                $display("  Outputs: r=%h, theta=%h",
                         r, theta);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%h, theta=%h",
                         expected_r, expected_theta);
                $display("  Got:      r=%h, theta=%h",
                         r, theta);
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
