`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg rst;
    wire [7:0] dout0;
    wire [7:0] dout1;
    wire [7:0] dout2;
    wire [7:0] dout3;
    wire [7:0] dout4;
    wire [7:0] dout5;
    wire [7:0] dout6;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .rst(rst),
        .dout0(dout0),
        .dout1(dout1),
        .dout2(dout2),
        .dout3(dout3),
        .dout4(dout4),
        .dout5(dout5),
        .dout6(dout6)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            #1;
            rst = 1;
            din = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset State Check");
            test_num = test_num + 1;


            @(posedge clk);
            #1;
            rst = 1;
            din = 8'hA5;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hA5, 8'hzz, 8'hzz, 8'hzz, 8'hzz, 8'hzz, 8'hzz);

            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Full Pipeline Shift");
            test_num = test_num + 1;
            reset_dut();


            din = 8'h01; @(posedge clk); #1;

            din = 8'h02; @(posedge clk); #1;

            din = 8'h03; @(posedge clk); #1;

            din = 8'h04; @(posedge clk); #1;

            din = 8'h05; @(posedge clk); #1;

            din = 8'h06; @(posedge clk); #1;

            din = 8'h07; @(posedge clk); #1;

            #1;


            check_outputs(8'h07, 8'h06, 8'h05, 8'h04, 8'h03, 8'h02, 8'h01);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: All-ones and All-zeros Shift");
            test_num = test_num + 1;
            reset_dut();


            din = 8'hFF; @(posedge clk); #1;
            din = 8'h00; @(posedge clk); #1;
            din = 8'h00; @(posedge clk); #1;
            din = 8'h00; @(posedge clk); #1;
            din = 8'h00; @(posedge clk); #1;
            din = 8'h00; @(posedge clk); #1;
            din = 8'h00; @(posedge clk); #1;


            #1;



            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Reset Recovery");
            test_num = test_num + 1;
            reset_dut();


            din = 8'hAA; @(posedge clk); #1;
            din = 8'hBB; @(posedge clk); #1;


            rst = 1; @(posedge clk); #1;
            rst = 0; @(posedge clk); #1;


            din = 8'hCC; @(posedge clk); #1;
            din = 8'hDD; @(posedge clk); #1;
            din = 8'hEE; @(posedge clk); #1;
            din = 8'h11; @(posedge clk); #1;
            din = 8'h22; @(posedge clk); #1;
            din = 8'h33; @(posedge clk); #1;
            din = 8'h44; @(posedge clk); #1;


            #1;



            check_outputs(8'h44, 8'h33, 8'h22, 8'h11, 8'hEE, 8'hDD, 8'hCC);
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
        input [7:0] expected_dout0;
        input [7:0] expected_dout1;
        input [7:0] expected_dout2;
        input [7:0] expected_dout3;
        input [7:0] expected_dout4;
        input [7:0] expected_dout5;
        input [7:0] expected_dout6;
        begin
            if (expected_dout0 === (expected_dout0 ^ dout0 ^ expected_dout0) &&
                expected_dout1 === (expected_dout1 ^ dout1 ^ expected_dout1) &&
                expected_dout2 === (expected_dout2 ^ dout2 ^ expected_dout2) &&
                expected_dout3 === (expected_dout3 ^ dout3 ^ expected_dout3) &&
                expected_dout4 === (expected_dout4 ^ dout4 ^ expected_dout4) &&
                expected_dout5 === (expected_dout5 ^ dout5 ^ expected_dout5) &&
                expected_dout6 === (expected_dout6 ^ dout6 ^ expected_dout6)) begin
                $display("PASS");
                $display("  Outputs: dout0=%h, dout1=%h, dout2=%h, dout3=%h, dout4=%h, dout5=%h, dout6=%h",
                         dout0, dout1, dout2, dout3, dout4, dout5, dout6);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout0=%h, dout1=%h, dout2=%h, dout3=%h, dout4=%h, dout5=%h, dout6=%h",
                         expected_dout0, expected_dout1, expected_dout2, expected_dout3, expected_dout4, expected_dout5, expected_dout6);
                $display("  Got:      dout0=%h, dout1=%h, dout2=%h, dout3=%h, dout4=%h, dout5=%h, dout6=%h",
                         dout0, dout1, dout2, dout3, dout4, dout5, dout6);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, din, rst, dout0, dout1, dout2, dout3, dout4, dout5, dout6);
    end

endmodule
