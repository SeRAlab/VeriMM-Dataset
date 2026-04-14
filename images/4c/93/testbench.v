`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din00;
    reg [7:0] din01;
    reg [7:0] din02;
    reg [7:0] din10;
    reg [7:0] din11;
    reg [7:0] din12;
    reg [7:0] din20;
    reg [7:0] din21;
    reg [7:0] din22;
    reg din_valid;
    reg resetn;
    wire [7:0] dout;
    wire dout_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din00(din00),
        .din01(din01),
        .din02(din02),
        .din10(din10),
        .din11(din11),
        .din12(din12),
        .din20(din20),
        .din21(din21),
        .din22(din22),
        .din_valid(din_valid),
        .resetn(resetn),
        .dout(dout),
        .dout_valid(dout_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            din_valid = 0;
            din00 = 0; din01 = 0; din02 = 0;
            din10 = 0; din11 = 0; din12 = 0;
            din20 = 0; din21 = 0; din22 = 0;
            #10;
            resetn = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            din00 = 0; din01 = 0; din02 = 0;
            din10 = 0; din11 = 0; din12 = 0;
            din20 = 0; din21 = 0; din22 = 0;
            din_valid = 1;
            @(posedge clk);
            din_valid = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            din00 = 255; din01 = 255; din02 = 255;
            din10 = 255; din11 = 255; din12 = 255;
            din20 = 255; din21 = 255; din22 = 255;
            din_valid = 1;
            @(posedge clk);
            din_valid = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            din00 = 10; din01 = 20; din02 = 30;
            din10 = 40; din11 = 50; din12 = 60;
            din20 = 70; din21 = 80; din22 = 90;
            din_valid = 1;
            @(posedge clk);
            din_valid = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd50, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            din00 = 2; din01 = 1; din02 = 1;
            din10 = 1; din11 = 1; din12 = 1;
            din20 = 1; din21 = 1; din22 = 1;
            din_valid = 1;
            @(posedge clk);
            din_valid = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            din00 = 100; din01 = 0; din02 = 0;
            din10 = 0; din11 = 0; din12 = 0;
            din20 = 0; din21 = 0; din22 = 0;
            din_valid = 1;
            @(posedge clk);
            din_valid = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd11, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            din00 = 9; din01 = 9; din02 = 9;
            din10 = 9; din11 = 9; din12 = 9;
            din20 = 9; din21 = 9; din22 = 9;
            din_valid = 1;
            @(posedge clk);
            din_valid = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd9, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            din00 = 50; din01 = 50; din02 = 50;
            din10 = 50; din11 = 50; din12 = 50;
            din20 = 50; din21 = 50; din22 = 50;
            din_valid = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0, 1'b0);
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
        input [7:0] expected_dout;
        input expected_dout_valid;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_dout_valid === (expected_dout_valid ^ dout_valid ^ expected_dout_valid)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, dout_valid=%b",
                         dout, dout_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, dout_valid=%b",
                         expected_dout, expected_dout_valid);
                $display("  Got:      dout=%h, dout_valid=%b",
                         dout, dout_valid);
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
        $dumpvars(0,clk, din00, din01, din02, din10, din11, din12, din20, din21, din22, din_valid, resetn, dout, dout_valid);
    end

endmodule
