`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg btnC;
    reg btnD;
    reg btnL;
    reg btnR;
    reg btnU;
    reg clk;
    reg [15:0] sw;
    wire [3:0] an;
    wire dp;
    wire [15:0] led;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .btnC(btnC),
        .btnD(btnD),
        .btnL(btnL),
        .btnR(btnR),
        .btnU(btnU),
        .clk(clk),
        .sw(sw),
        .an(an),
        .dp(dp),
        .led(led),
        .seg(seg)
    );
    task testcase001;

    begin
        test_num = 1;
        btnC = 0; btnU = 0; btnD = 0; btnR = 0; btnL = 0;
        sw = 16'h0000;

        #1;


        check_outputs(4'b0000, 1'b0, 16'h0000, 7'b1111111);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        btnC = 0; btnU = 0; btnD = 0; btnR = 0; btnL = 0;
        sw = 16'hAAAA;

        #1;


        check_outputs(4'b0000, 1'b0, 16'hAAAA, 7'b1111111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        btnC = 1; btnU = 0; btnD = 0; btnR = 0; btnL = 0;
        sw = 16'h0001;

        #1;


        check_outputs(4'b0000, 1'b1, 16'h0001, 7'b1111110);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        btnC = 0; btnU = 1; btnD = 0; btnR = 0; btnL = 0;
        sw = 16'h0002;

        #1;


        check_outputs(4'b0000, 1'b1, 16'h0002, 7'b1111101);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        btnC = 0; btnU = 0; btnD = 1; btnR = 0; btnL = 0;
        sw = 16'h0004;

        #1;


        check_outputs(4'b0000, 1'b1, 16'h0004, 7'b1111011);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        btnC = 0; btnU = 0; btnD = 0; btnR = 1; btnL = 0;
        sw = 16'h0008;

        #1;


        check_outputs(4'b0000, 1'b1, 16'h0008, 7'b1110111);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        btnC = 0; btnU = 0; btnD = 0; btnR = 0; btnL = 1;
        sw = 16'h0010;

        #1;


        check_outputs(4'b0000, 1'b1, 16'h0010, 7'b1101111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        btnC = 1; btnU = 1; btnD = 0; btnR = 0; btnL = 0;
        sw = 16'hFFFF;

        #1;


        check_outputs(4'b0000, 1'b1, 16'hFFFF, 7'b1111100);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        btnC = 1; btnU = 1; btnD = 1; btnR = 1; btnL = 1;
        sw = 16'h5555;

        #1;


        check_outputs(4'b0000, 1'b1, 16'h5555, 7'b1100000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        btnC = 0; btnU = 0; btnD = 0; btnR = 1; btnL = 1;
        sw = 16'h0000;

        #1;


        check_outputs(4'b0000, 1'b1, 16'h0000, 7'b1100111);
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
        input [3:0] expected_an;
        input expected_dp;
        input [15:0] expected_led;
        input [6:0] expected_seg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_an === (expected_an ^ an ^ expected_an) &&
                expected_dp === (expected_dp ^ dp ^ expected_dp) &&
                expected_led === (expected_led ^ led ^ expected_led) &&
                expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: an=%h, dp=%b, led=%h, seg=%h",
                         an, dp, led, seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: an=%h, dp=%b, led=%h, seg=%h",
                         expected_an, expected_dp, expected_led, expected_seg);
                $display("  Got:      an=%h, dp=%b, led=%h, seg=%h",
                         an, dp, led, seg);
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
