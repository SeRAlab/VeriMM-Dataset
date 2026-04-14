`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] mux;
    reg res;
    reg [7:0] shift;
    wire [26:0] outp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mux(mux),
        .res(res),
        .shift(shift),
        .outp(outp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            res = 0;
            shift = 0;
            mux = 0;
            @(posedge clk);
            #1 res = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            res = 0;
            mux = 32'hFFFFFFFF;
            shift = 8'h05;
            @(posedge clk);
            #1;
            #1;

            check_outputs(27'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            mux = 32'h8000000A;
            shift = 8'h03;
            @(posedge clk);
            #1;

            #1;


            check_outputs(27'h4000005);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            mux = 32'h000000FF;
            shift = 8'h02;
            @(posedge clk);
            #1;

            #1;


            check_outputs(27'h00000FF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            mux = 32'h8000FF00;
            shift = 8'h0A;
            @(posedge clk);
            #1;

            #1;


            check_outputs(27'h40000FF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            mux = 32'h8000000F;
            shift = 8'h02;
            @(posedge clk);
            #1;

            mux = 32'h00000000;
            shift = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(27'h400000F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            mux = 32'hFFFFFFFF;
            shift = 8'h20;
            @(posedge clk);
            #1;

            #1;


            check_outputs(27'h4000000);
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
        input [26:0] expected_outp;
        begin
            if (expected_outp === (expected_outp ^ outp ^ expected_outp)) begin
                $display("PASS");
                $display("  Outputs: outp=%h",
                         outp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outp=%h",
                         expected_outp);
                $display("  Got:      outp=%h",
                         outp);
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
        $dumpvars(0,clk, mux, res, shift, outp);
    end

endmodule
