`timescale 1ns/1ps

module hough_transform_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] binary_image;
    wire [15:0] r;
    wire [15:0] theta;

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
    task set_pixel;

        input integer x;
        input integer y;
        begin
            binary_image[y*16 + x] = 1'b1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Empty Image", test_num);
            binary_image = 256'b0;

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Horizontal Line at y=7", test_num);
            binary_image = 256'b0;
            for (i = 0; i < 16; i = i + 1) begin
                set_pixel(i, 7);
            end

            #1;


            check_outputs(16'h0007, 16'h005A);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Vertical Line at x=12", test_num);
            binary_image = 256'b0;
            for (i = 0; i < 16; i = i + 1) begin
                set_pixel(12, i);
            end

            #1;


            check_outputs(16'h000C, 16'h0000);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Diagonal Line (y=x)", test_num);
            binary_image = 256'b0;
            for (i = 0; i < 16; i = i + 1) begin
                set_pixel(i, i);
            end

            #1;


            check_outputs(16'h0000, 16'h002D);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Point at (5,5)", test_num);
            binary_image = 256'b0;
            set_pixel(5, 5);

            #1;


            check_outputs(16'h0005, 16'h0000);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Horizontal Line at y=0", test_num);
            binary_image = 256'b0;
            for (i = 0; i < 16; i = i + 1) begin
                set_pixel(i, 0);
            end

            #1;


            check_outputs(16'h0000, 16'h005A);
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
        input [15:0] expected_r;
        input [15:0] expected_theta;
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
