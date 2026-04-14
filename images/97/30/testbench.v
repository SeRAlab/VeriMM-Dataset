`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg [7:0] mux;
    reg res;
    reg [7:0] rounding;
    wire [7:0] outp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .mux(mux),
        .res(res),
        .rounding(rounding),
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
            en = 0;
            mux = 8'h00;
            rounding = 8'h00;
            @(posedge clk);
            #1;
            res = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Reset Check", test_num);
            reset_dut();

            res = 0;
            mux = 8'hFF;
            rounding = 8'hAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mux Selection (en=0)", test_num);
            reset_dut();
            res = 1;
            en = 0;
            mux = 8'h55;
            rounding = 8'hAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Rounding Selection (en=1)", test_num);
            reset_dut();
            res = 1;
            en = 1;
            mux = 8'h55;
            rounding = 8'hAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Priority Over Enable", test_num);
            reset_dut();
            res = 0;
            en = 1;
            mux = 8'h12;
            rounding = 8'h34;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data Toggle Check", test_num);
            reset_dut();
            res = 1;
            en = 0;
            mux = 8'hDE;
            rounding = 8'hAD;
            @(posedge clk);
            #1;

            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAD);
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
        input [7:0] expected_outp;
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
        $dumpvars(0,clk, en, mux, res, rounding, outp);
    end

endmodule
