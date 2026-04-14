`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_center;
    reg [7:0] pixel_left;
    reg [7:0] pixel_right;
    wire [7:0] output_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .pixel_center(pixel_center),
        .pixel_left(pixel_left),
        .pixel_right(pixel_right),
        .output_pixel(output_pixel)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs zero", test_num);
        pixel_left   = 8'h00;
        pixel_center = 8'h00;
        pixel_right  = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs at maximum", test_num);
        pixel_left   = 8'hFF;
        pixel_center = 8'hFF;
        pixel_right  = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Center pixel unique (Dark center)", test_num);
        pixel_left   = 8'hAA;
        pixel_center = 8'h00;
        pixel_right  = 8'hAA;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Center pixel unique (Bright center)", test_num);
        pixel_left   = 8'h55;
        pixel_center = 8'hFF;
        pixel_right  = 8'h55;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Gradient values", test_num);
        pixel_left   = 8'd10;
        pixel_center = 8'd20;
        pixel_right  = 8'd30;
        #1;

        check_outputs(8'd20);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-range values with bit patterns", test_num);
        pixel_left   = 8'b1010_1010;
        pixel_center = 8'b1100_1100;
        pixel_right  = 8'b0011_0011;
        #1;

        check_outputs(8'b1100_1100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large difference between neighbors", test_num);
        pixel_left   = 8'd0;
        pixel_center = 8'd128;
        pixel_right  = 8'd255;
        #1;

        check_outputs(8'd128);
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
        input [7:0] expected_output_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_pixel === (expected_output_pixel ^ output_pixel ^ expected_output_pixel)) begin
                $display("PASS");
                $display("  Outputs: output_pixel=%h",
                         output_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_pixel=%h",
                         expected_output_pixel);
                $display("  Got:      output_pixel=%h",
                         output_pixel);
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
