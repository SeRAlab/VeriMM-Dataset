`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg conv;
    reg [7:0] dac_in;
    reg rst;
    wire [7:0] dac_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .conv(conv),
        .dac_in(dac_in),
        .rst(rst),
        .dac_out(dac_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            conv = 0;
            dac_in = 8'h00;
            #10;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Conversion Cycle", test_num);
            reset_dut();
            conv = 1;
            @(posedge clk);
            #2;
            conv = 0;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: 5 Consecutive Conversions", test_num);
            reset_dut();
            repeat(5) begin
                conv = 1;
                @(posedge clk);
                #2;
            end
            conv = 0;






            #1;







            check_outputs(8'h04);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Counter Overflow (256 pulses)", test_num);
            reset_dut();
            repeat(256) begin
                conv = 1;
                @(posedge clk);
                #2;
            end
            conv = 0;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: First value after Wrap Around", test_num);
            reset_dut();
            repeat(257) begin
                conv = 1;
                @(posedge clk);
                #2;
            end
            conv = 0;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Conversion Gating (conv signal toggling)", test_num);
            reset_dut();


            repeat(3) begin
                conv = 1;
                @(posedge clk);
                #2;
            end


            conv = 0;
            repeat(3) begin
                @(posedge clk);
                #2;
            end


            conv = 1;
            @(posedge clk);
            #2;
            conv = 0;

            #1;


            check_outputs(8'h03);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Reset Mid-operation", test_num);
            reset_dut();


            repeat(10) begin
                conv = 1;
                @(posedge clk);
                #2;
            end


            rst = 1;
            @(posedge clk);
            #2;
            rst = 0;

            #1;


            check_outputs(8'h00);
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
        testcase007();
        
        
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
        input [7:0] expected_dac_out;
        begin
            if (expected_dac_out === (expected_dac_out ^ dac_out ^ expected_dac_out)) begin
                $display("PASS");
                $display("  Outputs: dac_out=%h",
                         dac_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dac_out=%h",
                         expected_dac_out);
                $display("  Got:      dac_out=%h",
                         dac_out);
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
        $dumpvars(0,clk, conv, dac_in, rst, dac_out);
    end

endmodule
