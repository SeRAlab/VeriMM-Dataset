`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_CLK;
    reg [13:0] i_DATA;
    reg [2:0] i_TC;
    wire [13:0] o_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_CLK(i_CLK),
        .i_DATA(i_DATA),
        .i_TC(i_TC),
        .o_OUT(o_OUT)
    );

        task reset_dut;

        begin
            i_DATA = 14'd0;
            i_TC = 3'd0;
            @(posedge i_CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            i_DATA = 14'h1234;
            i_TC = 3'd0;
            @(posedge i_CLK);
            #2;
            #1;

            check_outputs(14'h1234);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            i_DATA = 14'h2000;
            i_TC = 3'd1;
            @(posedge i_CLK);
            #2;
            #1;

            check_outputs(14'h1000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            i_DATA = 14'h0010;
            i_TC = 3'd2;
            @(posedge i_CLK);
            #2;
            #1;

            check_outputs(14'h0004);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            i_DATA = 14'h3FFF;
            i_TC = 3'd3;
            @(posedge i_CLK);
            #2;
            #1;

            check_outputs(14'h07FF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            i_DATA = 14'h0001;
            i_TC = 3'd1;
            @(posedge i_CLK);
            #2;
            #1;

            check_outputs(14'h0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            i_DATA = 14'h3FFF;
            i_TC = 3'd0;
            @(posedge i_CLK);
            #2;
            #1;

            check_outputs(14'h3FFF);
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
        input [13:0] expected_o_OUT;
        begin
            if (expected_o_OUT === (expected_o_OUT ^ o_OUT ^ expected_o_OUT)) begin
                $display("PASS");
                $display("  Outputs: o_OUT=%h",
                         o_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_OUT=%h",
                         expected_o_OUT);
                $display("  Got:      o_OUT=%h",
                         o_OUT);
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
        $dumpvars(0,i_CLK, i_DATA, i_TC, o_OUT);
    end

endmodule
