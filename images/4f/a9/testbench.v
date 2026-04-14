`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [31:0] input_d;
    reg reset;
    wire [31:0] output_q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .input_d(input_d),
        .reset(reset),
        .output_q(output_q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            clr = 0;
            input_d = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Load Value", test_num);
            reset_dut();
            input_d = 32'hDEADBEEF;
            clr = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Assert CLR (Hold Value)", test_num);
            reset_dut();

            input_d = 32'h12345678;
            clr = 0;
            @(posedge clk);

            @(negedge clk);
            clr = 1;
            input_d = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Reset Priority over CLR", test_num);
            reset_dut();

            input_d = 32'hAAAAAAAA;
            clr = 0;
            @(posedge clk);

            @(negedge clk);
            reset = 1;
            clr = 1;
            input_d = 32'hBBBBBBBB;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Multiple Sequential Updates", test_num);
            reset_dut();
            input_d = 32'h1;
            @(posedge clk);
            #1;
            input_d = 32'h2;
            @(posedge clk);
            #1;
            input_d = 32'h3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000003);
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
        input [31:0] expected_output_q;
        begin
            if (expected_output_q === (expected_output_q ^ output_q ^ expected_output_q)) begin
                $display("PASS");
                $display("  Outputs: output_q=%h",
                         output_q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_q=%h",
                         expected_output_q);
                $display("  Got:      output_q=%h",
                         output_q);
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
        $dumpvars(0,clk, clr, input_d, reset, output_q);
    end

endmodule
