`timescale 1ns/1ps

module gaussian_blur_tb;

    // Testbench signals (combinational circuit)
    reg [71:0] pixel_matrix;
    wire [7:0] blurred_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gaussian_blur dut (
        .pixel_matrix(pixel_matrix),
        .blurred_pixel(blurred_pixel)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest %0d: All Zeros", test_num);
        pixel_matrix = 72'h0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest %0d: All Pixels Max (255)", test_num);
        pixel_matrix = {8'd255, 8'd255, 8'd255, 8'd255, 8'd255, 8'd255, 8'd255, 8'd255, 8'd255};
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest %0d: Gradient Input (Avg 50)", test_num);
        pixel_matrix = {8'd10, 8'd20, 8'd30, 8'd40, 8'd50, 8'd60, 8'd70, 8'd80, 8'd90};
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest %0d: Uniform Intermediate Value (128)", test_num);
        pixel_matrix = {9{8'd128}};
        #1;

        check_outputs(8'd128);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest %0d: Truncation Check (Sum 10, Avg 1)", test_num);
        pixel_matrix = {8'd1, 8'd1, 8'd1, 8'd1, 8'd1, 8'd1, 8'd1, 8'd1, 8'd2};
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest %0d: Truncation Check (Sum 8, Avg 0)", test_num);
        pixel_matrix = {8'd8, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0};
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest %0d: Mixed High Values (Avg 111)", test_num);
        pixel_matrix = {8'd200, 8'd0, 8'd200, 8'd0, 8'd200, 8'd0, 8'd200, 8'd0, 8'd200};
        #1;

        check_outputs(8'd111);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gaussian_blur Testbench");
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
        input [7:0] expected_blurred_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_blurred_pixel === (expected_blurred_pixel ^ blurred_pixel ^ expected_blurred_pixel)) begin
                $display("PASS");
                $display("  Outputs: blurred_pixel=%h",
                         blurred_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blurred_pixel=%h",
                         expected_blurred_pixel);
                $display("  Got:      blurred_pixel=%h",
                         blurred_pixel);
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
