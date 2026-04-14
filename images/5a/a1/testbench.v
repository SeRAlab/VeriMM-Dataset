`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [13:0] data_in;
    reg dir;
    reg enable;
    reg reset;
    wire [13:0] shift_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .dir(dir),
        .enable(enable),
        .reset(reset),
        .shift_reg(shift_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            dir = 0;
            data_in = 14'b0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(14'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift Left (dir=0)", test_num);
            reset_dut();

            enable = 1;
            dir = 0;
            data_in = 14'h0001;
            @(posedge clk);
            #1;
            data_in = 14'h0000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(14'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift Right (dir=1)", test_num);
            reset_dut();


            enable = 1; dir = 0; data_in = 14'h0001;
            @(posedge clk); #1;


            dir = 1;
            data_in = 14'h0000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(14'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable/Disable (Hold Value)", test_num);
            reset_dut();


            enable = 1; dir = 0; data_in = 14'h0001;
            @(posedge clk); #1;


            enable = 0;
            @(posedge clk); #1;
            @(posedge clk); #1;

            #1;


            check_outputs(14'h0001);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 14-bit Left Shift Propagation", test_num);
            reset_dut();

            enable = 1; dir = 0; data_in = 14'h0001;
            @(posedge clk); #1;

            data_in = 14'h0000;
            for(i=0; i<13; i=i+1) begin
                @(posedge clk); #1;
            end

            #1;


            check_outputs(14'h2000);
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
        input [13:0] expected_shift_reg;
        begin
            if (expected_shift_reg === (expected_shift_reg ^ shift_reg ^ expected_shift_reg)) begin
                $display("PASS");
                $display("  Outputs: shift_reg=%h",
                         shift_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shift_reg=%h",
                         expected_shift_reg);
                $display("  Got:      shift_reg=%h",
                         shift_reg);
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
        $dumpvars(0,clk, data_in, dir, enable, reset, shift_reg);
    end

endmodule
