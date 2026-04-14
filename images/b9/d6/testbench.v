`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [25:0] VGA_SCA_RGB_Str_i;
    wire ActiveVideo;
    wire Blue;
    wire Green;
    wire HSync;
    wire Red;
    wire VSync;
    wire [9:0] XCoord;
    wire [9:0] YCoord;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .VGA_SCA_RGB_Str_i(VGA_SCA_RGB_Str_i),
        .ActiveVideo(ActiveVideo),
        .Blue(Blue),
        .Green(Green),
        .HSync(HSync),
        .Red(Red),
        .VSync(VSync),
        .XCoord(XCoord),
        .YCoord(YCoord)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: All Zeros");
        VGA_SCA_RGB_Str_i = 26'b0;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0, 10'd0, 10'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: HSync Active");
        VGA_SCA_RGB_Str_i = (1 << 25);
        #1;

        check_outputs(0, 0, 0, 1, 0, 0, 10'd0, 10'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: VSync Active");
        VGA_SCA_RGB_Str_i = (1 << 24);
        #1;

        check_outputs(0, 0, 0, 0, 0, 1, 10'd0, 10'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Red Active");
        VGA_SCA_RGB_Str_i = (1 << 23);
        #1;

        check_outputs(0, 0, 0, 0, 1, 0, 10'd0, 10'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Green Active");
        VGA_SCA_RGB_Str_i = (1 << 22);
        #1;

        check_outputs(0, 0, 1, 0, 0, 0, 10'd0, 10'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Blue Active");
        VGA_SCA_RGB_Str_i = (1 << 21);
        #1;

        check_outputs(0, 1, 0, 0, 0, 0, 10'd0, 10'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Max XCoord");
        VGA_SCA_RGB_Str_i = (10'h3FF << 11);
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 10'h3FF, 10'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Max YCoord");
        VGA_SCA_RGB_Str_i = (10'h3FF << 1);
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 10'd0, 10'h3FF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: ActiveVideo On");
        VGA_SCA_RGB_Str_i = (1 << 0);
        #1;

        check_outputs(1, 0, 0, 0, 0, 0, 10'd0, 10'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: Combined Signal (Active, Magenta, X=640, Y=480)");

        VGA_SCA_RGB_Str_i = (0<<25)|(0<<24)|(1<<23)|(0<<22)|(1<<21)|(10'd640<<11)|(10'd480<<1)|(1<<0);
        #1;

        check_outputs(1, 1, 0, 0, 1, 0, 10'd640, 10'd480);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_ActiveVideo;
        input expected_Blue;
        input expected_Green;
        input expected_HSync;
        input expected_Red;
        input expected_VSync;
        input [9:0] expected_XCoord;
        input [9:0] expected_YCoord;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ActiveVideo === (expected_ActiveVideo ^ ActiveVideo ^ expected_ActiveVideo) &&
                expected_Blue === (expected_Blue ^ Blue ^ expected_Blue) &&
                expected_Green === (expected_Green ^ Green ^ expected_Green) &&
                expected_HSync === (expected_HSync ^ HSync ^ expected_HSync) &&
                expected_Red === (expected_Red ^ Red ^ expected_Red) &&
                expected_VSync === (expected_VSync ^ VSync ^ expected_VSync) &&
                expected_XCoord === (expected_XCoord ^ XCoord ^ expected_XCoord) &&
                expected_YCoord === (expected_YCoord ^ YCoord ^ expected_YCoord)) begin
                $display("PASS");
                $display("  Outputs: ActiveVideo=%b, Blue=%b, Green=%b, HSync=%b, Red=%b, VSync=%b, XCoord=%h, YCoord=%h",
                         ActiveVideo, Blue, Green, HSync, Red, VSync, XCoord, YCoord);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ActiveVideo=%b, Blue=%b, Green=%b, HSync=%b, Red=%b, VSync=%b, XCoord=%h, YCoord=%h",
                         expected_ActiveVideo, expected_Blue, expected_Green, expected_HSync, expected_Red, expected_VSync, expected_XCoord, expected_YCoord);
                $display("  Got:      ActiveVideo=%b, Blue=%b, Green=%b, HSync=%b, Red=%b, VSync=%b, XCoord=%h, YCoord=%h",
                         ActiveVideo, Blue, Green, HSync, Red, VSync, XCoord, YCoord);
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
