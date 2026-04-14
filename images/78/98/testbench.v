`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in0;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    reg rst;
    wire [3:0] anodo;
    wire [7:0] catodo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .rst(rst),
        .anodo(anodo),
        .catodo(catodo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in0 = 8'hAA;
            in1 = 8'hBB;
            in2 = 8'hCC;
            in3 = 8'hDD;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            #1;



            check_outputs(4'b1110, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b1101, 8'hBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(4'b1011, 8'hCC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0111, 8'hDD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            repeat(4) @(posedge clk);
            #2;

            #1;


            check_outputs(4'b1110, 8'hAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            repeat(1) @(posedge clk);
            #5;
            in1 = 8'h55;
            #5;

            #1;


            check_outputs(4'b1101, 8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            repeat(2) @(posedge clk);
            #2;
            rst = 1;
            #5;

            #1;


            check_outputs(4'b1110, 8'hAA);
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
        input [3:0] expected_anodo;
        input [7:0] expected_catodo;
        begin
            if (expected_anodo === (expected_anodo ^ anodo ^ expected_anodo) &&
                expected_catodo === (expected_catodo ^ catodo ^ expected_catodo)) begin
                $display("PASS");
                $display("  Outputs: anodo=%h, catodo=%h",
                         anodo, catodo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: anodo=%h, catodo=%h",
                         expected_anodo, expected_catodo);
                $display("  Got:      anodo=%h, catodo=%h",
                         anodo, catodo);
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
        $dumpvars(0,clk, in0, in1, in2, in3, rst, anodo, catodo);
    end

endmodule
