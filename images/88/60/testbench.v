`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] d1;
    reg [3:0] d2;
    reg enable;
    reg reset;
    wire [3:0] q;
    wire [3:0] xor_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d1(d1),
        .d2(d2),
        .enable(enable),
        .reset(reset),
        .q(q),
        .xor_output(xor_output)
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
            d1 = 4'b0;
            d2 = 4'b0;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Loading Reg1 with 1s, Reg2 with 0s", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            d1 = 4'b0001; d2 = 4'b0000;
            @(posedge clk);
            d1 = 4'b0001; d2 = 4'b0000;
            @(posedge clk);
            d1 = 4'b0001; d2 = 4'b0000;
            @(posedge clk);
            d1 = 4'b0001; d2 = 4'b0000;
            @(posedge clk);
            enable = 0;

            #1;


            check_outputs(4'b0000, 4'b1111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Shifting 1010 into Reg1 and 0110 into Reg2", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            d1 = 4'b0001; d2 = 4'b0000;
            @(posedge clk);
            d1 = 4'b0000; d2 = 4'b0001;
            @(posedge clk);
            d1 = 4'b0001; d2 = 4'b0001;
            @(posedge clk);
            d1 = 4'b0000; d2 = 4'b0000;
            @(posedge clk);
            enable = 0;

            #1;


            check_outputs(4'b0110, 4'b1100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Shifting with Enable toggling", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1; d1 = 4'b0001; d2 = 4'b0001;
            @(posedge clk);
            enable = 0; d1 = 4'b0000; d2 = 4'b0000;
            @(posedge clk);
            enable = 1; d1 = 4'b0001; d2 = 4'b0000;
            @(posedge clk);
            enable = 0;
            @(posedge clk);

            #1;


            check_outputs(4'b0010, 4'b0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Asynchronous Reset during operation", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1; d1 = 4'b1111; d2 = 4'b1111;
            @(posedge clk);
            @(posedge clk);
            reset = 1;
            #2;
            #1;

            check_outputs(4'b0000, 4'b0000);
            #8;
            reset = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Shifting 1s into both registers", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1; d1 = 4'hf; d2 = 4'hf;
            @(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk);
            @(posedge clk);
            enable = 0;

            #1;


            check_outputs(4'b1111, 4'b0000);
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
        input [3:0] expected_q;
        input [3:0] expected_xor_output;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_xor_output === (expected_xor_output ^ xor_output ^ expected_xor_output)) begin
                $display("PASS");
                $display("  Outputs: q=%h, xor_output=%h",
                         q, xor_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, xor_output=%h",
                         expected_q, expected_xor_output);
                $display("  Got:      q=%h, xor_output=%h",
                         q, xor_output);
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
        $dumpvars(0,clk, d1, d2, enable, reset, q, xor_output);
    end

endmodule
