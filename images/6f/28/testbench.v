`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg EscrReg;
    reg clk;
    reg [31:0] datain;
    reg reset;
    wire [31:0] data1;
    wire [31:0] data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EscrReg(EscrReg),
        .clk(clk),
        .datain(datain),
        .reset(reset),
        .data1(data1),
        .data2(data2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            datain = 0;
            EscrReg = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset check...");
            reset_dut();
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Simple addition...");
            reset_dut();
            @(posedge clk);
            EscrReg = 0;
            datain = 32'd1000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'd1000, 32'd1000);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Sequential additions...");
            reset_dut();


            @(posedge clk);
            EscrReg = 0;
            datain = 32'd500;


            @(posedge clk);
            EscrReg = 0;
            datain = 32'd250;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'd750, 32'd250);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Subtraction with adjustment...");
            reset_dut();



            @(posedge clk);
            EscrReg = 0;
            datain = 32'd100;



            @(posedge clk);
            EscrReg = 1;
            datain = 32'd20;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd44, 32'd20);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Complex sequence...");
            reset_dut();


            @(posedge clk);
            EscrReg = 0;
            datain = 32'd200;


            @(posedge clk);
            EscrReg = 0;
            datain = 32'd100;


            @(posedge clk);
            EscrReg = 1;
            datain = 32'd50;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd206, 32'd50);
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
        input [31:0] expected_data1;
        input [31:0] expected_data2;
        begin
            if (expected_data1 === (expected_data1 ^ data1 ^ expected_data1) &&
                expected_data2 === (expected_data2 ^ data2 ^ expected_data2)) begin
                $display("PASS");
                $display("  Outputs: data1=%h, data2=%h",
                         data1, data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data1=%h, data2=%h",
                         expected_data1, expected_data2);
                $display("  Got:      data1=%h, data2=%h",
                         data1, data2);
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
        $dumpvars(0,EscrReg, clk, datain, reset, data1, data2);
    end

endmodule
