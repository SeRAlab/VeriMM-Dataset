`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dat_i;
    reg lchar_i;
    reg reset;
    reg valid_i;
    wire d;
    wire ready_o;
    wire s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dat_i(dat_i),
        .lchar_i(lchar_i),
        .reset(reset),
        .valid_i(valid_i),
        .d(d),
        .ready_o(ready_o),
        .s(s)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid_i = 0;
            dat_i = 8'b0;
            lchar_i = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);

            while (!ready_o) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data 0x00", test_num);
            reset_dut();
            dat_i = 8'h00;
            valid_i = 1;
            lchar_i = 1;
            @(posedge clk);
            #1 valid_i = 0;

            repeat(12) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data 0xFF", test_num);
            reset_dut();
            dat_i = 8'hFF;
            valid_i = 1;
            lchar_i = 1;
            @(posedge clk);
            #1 valid_i = 0;
            repeat(12) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data 0x55", test_num);
            reset_dut();
            dat_i = 8'h55;
            valid_i = 1;
            lchar_i = 1;
            @(posedge clk);
            #1 valid_i = 0;
            repeat(12) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data 0x01", test_num);
            reset_dut();
            dat_i = 8'h01;
            valid_i = 1;
            lchar_i = 1;
            @(posedge clk);
            #1 valid_i = 0;
            repeat(12) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data 0xA5", test_num);
            reset_dut();
            dat_i = 8'hA5;
            valid_i = 1;
            lchar_i = 1;
            @(posedge clk);
            #1 valid_i = 0;
            repeat(12) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b1, 1'b0);
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
        input expected_d;
        input expected_ready_o;
        input expected_s;
        begin
            if (expected_d === (expected_d ^ d ^ expected_d) &&
                expected_ready_o === (expected_ready_o ^ ready_o ^ expected_ready_o) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: d=%b, ready_o=%b, s=%b",
                         d, ready_o, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d=%b, ready_o=%b, s=%b",
                         expected_d, expected_ready_o, expected_s);
                $display("  Got:      d=%b, ready_o=%b, s=%b",
                         d, ready_o, s);
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
        $dumpvars(0,clk, dat_i, lchar_i, reset, valid_i, d, ready_o, s);
    end

endmodule
