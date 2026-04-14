`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg ena;
    reg rst;
    wire [7:0] accum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .ena(ena),
        .rst(rst),
        .accum(accum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ena = 0;
            data = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Testing Initial Reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Capture data when ena=1", test_num);
            reset_dut();
            ena = 1;
            data = 8'hA5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Hold value when ena=0", test_num);
            reset_dut();

            ena = 1;
            data = 8'h55;
            @(posedge clk);
            #1;

            ena = 0;
            data = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Sequential data updates", test_num);
            reset_dut();
            ena = 1;
            data = 8'h11;
            @(posedge clk);
            #1;
            data = 8'h22;
            @(posedge clk);
            #1;
            data = 8'h33;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Reset priority test", test_num);
            reset_dut();

            ena = 1;
            data = 8'hAA;
            @(posedge clk);
            #1;

            rst = 1;
            data = 8'hBB;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Toggling enable signal", test_num);
            reset_dut();


            ena = 1; data = 8'h10;
            @(posedge clk); #1;


            ena = 0; data = 8'h20;
            @(posedge clk); #1;


            ena = 1; data = 8'h30;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h30);
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
        input [7:0] expected_accum;
        begin
            if (expected_accum === (expected_accum ^ accum ^ expected_accum)) begin
                $display("PASS");
                $display("  Outputs: accum=%h",
                         accum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: accum=%h",
                         expected_accum);
                $display("  Got:      accum=%h",
                         accum);
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
        $dumpvars(0,clk, data, ena, rst, accum);
    end

endmodule
