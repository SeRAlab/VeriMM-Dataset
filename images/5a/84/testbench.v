`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] pushValue;
    reg rst;
    reg [1:0] stackCntrl;
    wire [11:0] popValue;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pushValue(pushValue),
        .rst(rst),
        .stackCntrl(stackCntrl),
        .popValue(popValue)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            stackCntrl = NOP;
            pushValue = 0;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            @(negedge clk);
            stackCntrl = PUSH;
            pushValue = 12'hAAA;
            @(negedge clk);
            stackCntrl = NOP;

            @(negedge clk);
            stackCntrl = POP;
            @(posedge clk);
            #1;

            check_outputs(12'hAAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            @(negedge clk);
            stackCntrl = PUSH;
            pushValue = 12'h111;

            @(negedge clk);
            stackCntrl = PUSH;
            pushValue = 12'h222;
            @(negedge clk);
            stackCntrl = NOP;

            @(negedge clk);
            stackCntrl = POP;
            @(posedge clk);
            #1;

            check_outputs(12'h222);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            @(negedge clk);
            stackCntrl = PUSH; pushValue = 12'h001;
            @(negedge clk);
            stackCntrl = PUSH; pushValue = 12'h002;
            @(negedge clk);
            stackCntrl = PUSH; pushValue = 12'h003;

            @(negedge clk);
            stackCntrl = POP;
            @(negedge clk);
            stackCntrl = POP;
            @(negedge clk);
            stackCntrl = POP;
            @(posedge clk);
            #1;

            check_outputs(12'h001);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            @(negedge clk);
            stackCntrl = PUSH; pushValue = 12'h555;

            @(negedge clk);
            stackCntrl = PUSH; pushValue = 12'h666;

            @(negedge clk);
            stackCntrl = POP;

            @(negedge clk);
            stackCntrl = PUSH; pushValue = 12'h777;

            @(negedge clk);
            stackCntrl = POP;
            @(posedge clk);
            #1;

            check_outputs(12'h777);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            @(negedge clk);
            stackCntrl = PUSH; pushValue = 12'h999;

            @(negedge clk);
            stackCntrl = NOP;

            @(negedge clk);
            stackCntrl = POP;
            @(posedge clk);
            #1;

            check_outputs(12'h999);
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
        input [11:0] expected_popValue;
        begin
            if (expected_popValue === (expected_popValue ^ popValue ^ expected_popValue)) begin
                $display("PASS");
                $display("  Outputs: popValue=%h",
                         popValue);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: popValue=%h",
                         expected_popValue);
                $display("  Got:      popValue=%h",
                         popValue);
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
        $dumpvars(0,clk, pushValue, rst, stackCntrl, popValue);
    end

endmodule
