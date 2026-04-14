`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d1;
    reg [7:0] d2;
    reg reset;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d1(d1),
        .d2(d2),
        .reset(reset),
        .q(q)
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
            d1 = 8'hAA;
            d2 = 8'h55;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            d1 = 8'd20;
            d2 = 8'd5;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Basic Subtraction (20 - 5)", test_num);
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            d1 = 8'd100;
            d2 = 8'd100;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Zero Result (100 - 100)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            d1 = 8'd10;
            d2 = 8'd20;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Wrap-around (10 - 20)", test_num);
            #1;

            check_outputs(8'hF6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            d1 = 8'hFF;
            d2 = 8'h00;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Max value (255 - 0)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            d1 = 8'd50;
            d2 = 8'd10;
            @(negedge clk);
            reset = 1;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Reset Priority (Reset high with inputs present)", test_num);

            #1;


            check_outputs(8'd0);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            d1 = 8'd30; d2 = 8'd10;
            @(posedge clk);
            #2;


            d1 = 8'd50; d2 = 8'd5;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Sequential update (50 - 5)", test_num);
            #1;

            check_outputs(8'd45);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d1, d2, reset, q);
    end

endmodule
