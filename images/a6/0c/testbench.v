`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg fifo_data_out;
    reg iDATA;
    reg [1:0] iX_Cont;
    reg [1:0] iY_Cont;
    wire [7:0] lower_row_pixel;
    wire [7:0] lower_row_pixel_delayed;
    wire [7:0] mCCD_B;
    wire [7:0] mCCD_G;
    wire [7:0] mCCD_R;
    wire mDVAL;
    wire [7:0] upper_row_pixel;
    wire [7:0] upper_row_pixel_delayed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fifo_data_out(fifo_data_out),
        .iDATA(iDATA),
        .iX_Cont(iX_Cont),
        .iY_Cont(iY_Cont),
        .lower_row_pixel(lower_row_pixel),
        .lower_row_pixel_delayed(lower_row_pixel_delayed),
        .mCCD_B(mCCD_B),
        .mCCD_G(mCCD_G),
        .mCCD_R(mCCD_R),
        .mDVAL(mDVAL),
        .upper_row_pixel(upper_row_pixel),
        .upper_row_pixel_delayed(upper_row_pixel_delayed)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Origin (X=0, Y=0)", test_num);

            iX_Cont = 2'b00; iY_Cont = 2'b00;
            iDATA = 1'b1; fifo_data_out = 1'b0;




            #1;





            check_outputs(8'h01, 8'h00, 8'h00, 8'h00, 8'h00, 1'b0, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Top Row (X=1, Y=0)", test_num);
            iX_Cont = 2'b01; iY_Cont = 2'b00;
            iDATA = 1'b0; fifo_data_out = 1'b1;


            #1;



            check_outputs(8'h00, 8'h00, 8'h00, 8'h01, 8'h00, 1'b0, 8'h01, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Bottom Row Start (X=0, Y=1)", test_num);
            iX_Cont = 2'b00; iY_Cont = 2'b01;
            iDATA = 1'b1; fifo_data_out = 1'b1;


            #1;



            check_outputs(8'h01, 8'h00, 8'h00, 8'h01, 8'h00, 1'b0, 8'h01, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Active Region (X=1, Y=1)", test_num);
            iX_Cont = 2'b01; iY_Cont = 2'b01;
            iDATA = 1'b1; fifo_data_out = 1'b1;



            #1;




            check_outputs(8'h01, 8'h01, 8'h01, 8'h00, 8'h00, 1'b1, 8'h01, 8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary (X=3, Y=3)", test_num);
            iX_Cont = 2'b11; iY_Cont = 2'b11;
            iDATA = 1'b0; fifo_data_out = 1'b0;


            #1;



            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 1'b1, 8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data Toggle", test_num);
            iX_Cont = 2'b01; iY_Cont = 2'b01;
            iDATA = 1'b1; fifo_data_out = 1'b0;
            #5;
            iDATA = 1'b0; fifo_data_out = 1'b1;


            #1;



            check_outputs(8'h00, 8'h01, 8'h00, 8'h01, 8'h00, 1'b1, 8'h01, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [7:0] expected_lower_row_pixel;
        input [7:0] expected_lower_row_pixel_delayed;
        input [7:0] expected_mCCD_B;
        input [7:0] expected_mCCD_G;
        input [7:0] expected_mCCD_R;
        input expected_mDVAL;
        input [7:0] expected_upper_row_pixel;
        input [7:0] expected_upper_row_pixel_delayed;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lower_row_pixel === (expected_lower_row_pixel ^ lower_row_pixel ^ expected_lower_row_pixel) &&
                expected_lower_row_pixel_delayed === (expected_lower_row_pixel_delayed ^ lower_row_pixel_delayed ^ expected_lower_row_pixel_delayed) &&
                expected_mCCD_B === (expected_mCCD_B ^ mCCD_B ^ expected_mCCD_B) &&
                expected_mCCD_G === (expected_mCCD_G ^ mCCD_G ^ expected_mCCD_G) &&
                expected_mCCD_R === (expected_mCCD_R ^ mCCD_R ^ expected_mCCD_R) &&
                expected_mDVAL === (expected_mDVAL ^ mDVAL ^ expected_mDVAL) &&
                expected_upper_row_pixel === (expected_upper_row_pixel ^ upper_row_pixel ^ expected_upper_row_pixel) &&
                expected_upper_row_pixel_delayed === (expected_upper_row_pixel_delayed ^ upper_row_pixel_delayed ^ expected_upper_row_pixel_delayed)) begin
                $display("PASS");
                $display("  Outputs: lower_row_pixel=%h, lower_row_pixel_delayed=%h, mCCD_B=%h, mCCD_G=%h, mCCD_R=%h, mDVAL=%b, upper_row_pixel=%h, upper_row_pixel_delayed=%h",
                         lower_row_pixel, lower_row_pixel_delayed, mCCD_B, mCCD_G, mCCD_R, mDVAL, upper_row_pixel, upper_row_pixel_delayed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lower_row_pixel=%h, lower_row_pixel_delayed=%h, mCCD_B=%h, mCCD_G=%h, mCCD_R=%h, mDVAL=%b, upper_row_pixel=%h, upper_row_pixel_delayed=%h",
                         expected_lower_row_pixel, expected_lower_row_pixel_delayed, expected_mCCD_B, expected_mCCD_G, expected_mCCD_R, expected_mDVAL, expected_upper_row_pixel, expected_upper_row_pixel_delayed);
                $display("  Got:      lower_row_pixel=%h, lower_row_pixel_delayed=%h, mCCD_B=%h, mCCD_G=%h, mCCD_R=%h, mDVAL=%b, upper_row_pixel=%h, upper_row_pixel_delayed=%h",
                         lower_row_pixel, lower_row_pixel_delayed, mCCD_B, mCCD_G, mCCD_R, mDVAL, upper_row_pixel, upper_row_pixel_delayed);
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
