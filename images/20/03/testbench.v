`timescale 1ns/1ps

module gaussian_blur_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_in_00;
    reg [7:0] pixel_in_01;
    reg [7:0] pixel_in_02;
    reg [7:0] pixel_in_10;
    reg [7:0] pixel_in_11;
    reg [7:0] pixel_in_12;
    reg [7:0] pixel_in_20;
    reg [7:0] pixel_in_21;
    reg [7:0] pixel_in_22;
    wire [7:0] pixel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gaussian_blur dut (
        .pixel_in_00(pixel_in_00),
        .pixel_in_01(pixel_in_01),
        .pixel_in_02(pixel_in_02),
        .pixel_in_10(pixel_in_10),
        .pixel_in_11(pixel_in_11),
        .pixel_in_12(pixel_in_12),
        .pixel_in_20(pixel_in_20),
        .pixel_in_21(pixel_in_21),
        .pixel_in_22(pixel_in_22),
        .pixel_out(pixel_out)
    );
    task clear_inputs;

        begin
            pixel_in_00 = 8'd0; pixel_in_01 = 8'd0; pixel_in_02 = 8'd0;
            pixel_in_10 = 8'd0; pixel_in_11 = 8'd0; pixel_in_12 = 8'd0;
            pixel_in_20 = 8'd0; pixel_in_21 = 8'd0; pixel_in_22 = 8'd0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            clear_inputs();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Max (255)", test_num);
            pixel_in_00 = 8'hFF; pixel_in_01 = 8'hFF; pixel_in_02 = 8'hFF;
            pixel_in_10 = 8'hFF; pixel_in_11 = 8'hFF; pixel_in_12 = 8'hFF;
            pixel_in_20 = 8'hFF; pixel_in_21 = 8'hFF; pixel_in_22 = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Center Impulse", test_num);
            clear_inputs();
            pixel_in_11 = 8'd16;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Horizontal Line", test_num);
            clear_inputs();
            pixel_in_10 = 8'd80; pixel_in_11 = 8'd80; pixel_in_12 = 8'd80;
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Vertical Line", test_num);
            clear_inputs();
            pixel_in_01 = 8'd120; pixel_in_11 = 8'd120; pixel_in_21 = 8'd120;
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Gradient Pattern", test_num);
            pixel_in_00 = 8'd10; pixel_in_01 = 8'd20; pixel_in_02 = 8'd30;
            pixel_in_10 = 8'd40; pixel_in_11 = 8'd50; pixel_in_12 = 8'd60;
            pixel_in_20 = 8'd70; pixel_in_21 = 8'd80; pixel_in_22 = 8'd90;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rounding Down (Sum < 16)", test_num);
            clear_inputs();
            pixel_in_00 = 8'd15;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Checkerboard Pattern", test_num);
            pixel_in_00 = 8'hFF; pixel_in_01 = 8'h00; pixel_in_02 = 8'hFF;
            pixel_in_10 = 8'h00; pixel_in_11 = 8'hFF; pixel_in_12 = 8'h00;
            pixel_in_20 = 8'hFF; pixel_in_21 = 8'h00; pixel_in_22 = 8'hFF;
            #1;

            check_outputs(8'h7F);
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
        input [7:0] expected_pixel_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pixel_out === (expected_pixel_out ^ pixel_out ^ expected_pixel_out)) begin
                $display("PASS");
                $display("  Outputs: pixel_out=%h",
                         pixel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pixel_out=%h",
                         expected_pixel_out);
                $display("  Got:      pixel_out=%h",
                         pixel_out);
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
