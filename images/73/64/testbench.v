`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] coef;
    reg dclr;
    reg [7:0] din;
    reg ena;
    wire [26:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .coef(coef),
        .dclr(dclr),
        .din(din),
        .ena(ena),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            dclr = 1;
            ena = 0;
            din = 0;
            coef = 0;
            @(posedge clk);
            #1;
            dclr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Accumulation", test_num);
            reset_dut();


            ena = 1; din = 8'd2; coef = 16'd5;
            @(posedge clk); #1;


            din = 8'd3; coef = 16'd10;
            @(posedge clk); #1;

            ena = 0;
            #1;

            check_outputs(27'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Signed (Negative) Accumulation", test_num);
            reset_dut();


            ena = 1; din = -8'd2; coef = 16'd5;
            @(posedge clk); #1;


            din = 8'd4; coef = -16'd10;
            @(posedge clk); #1;

            ena = 0;

            #1;


            check_outputs(27'sh7FFFFCE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable Signal Control", test_num);
            reset_dut();


            ena = 1; din = 8'd5; coef = 16'd2;
            @(posedge clk); #1;


            ena = 0; din = 8'd10; coef = 16'd10;
            @(posedge clk); #1;
            @(posedge clk); #1;

            #1;


            check_outputs(27'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Clear Signal (dclr)", test_num);
            reset_dut();


            ena = 1; din = 8'd10; coef = 16'd10;
            @(posedge clk); #1;


            dclr = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(27'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Values and Sign Extension", test_num);
            reset_dut();



            ena = 1; din = 8'h7F; coef = 16'h7FFF;
            @(posedge clk); #1;




            din = 8'h80; coef = 16'h8000;
            @(posedge clk); #1;

            ena = 0;
            #1;

            check_outputs(27'd8355713);
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
        input [26:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, coef, dclr, din, ena, result);
    end

endmodule
