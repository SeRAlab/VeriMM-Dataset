`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg EN;
    reg TE;
    reg [31:0] data_in;
    wire ENCLK;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .EN(EN),
        .TE(TE),
        .data_in(data_in),
        .ENCLK(ENCLK),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        EN = 0;
        TE = 0;
        data_in = 32'h0;
        @(negedge CLK);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        data_in = 32'hAAAA_BBBB;
        EN = 1;
        TE = 1;
        @(posedge CLK);

        #2;
        #1;

        check_outputs(1'b1, 32'hAAAA_BBBB);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        data_in = 32'h1234_5678;
        EN = 0;
        TE = 1;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(1'b0, 32'h0000_0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        data_in = 32'hDEAD_BEEF;
        EN = 1;
        TE = 0;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b0, 32'h0000_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        data_in = 32'hFFFF_FFFF;
        EN = 0;
        TE = 0;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b0, 32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();


        EN = 1; TE = 1;
        data_in = 32'hCAFE_BABE;
        @(posedge CLK);
        #2;


        @(negedge CLK);
        EN = 0;
        data_in = 32'hBADC_0DE1;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(1'b0, 32'hCAFE_BABE);
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
        input expected_ENCLK;
        input [31:0] expected_data_out;
        begin
            if (expected_ENCLK === (expected_ENCLK ^ ENCLK ^ expected_ENCLK) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ENCLK=%b, data_out=%h",
                         ENCLK, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ENCLK=%b, data_out=%h",
                         expected_ENCLK, expected_data_out);
                $display("  Got:      ENCLK=%b, data_out=%h",
                         ENCLK, data_out);
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
        $dumpvars(0,CLK, EN, TE, data_in, ENCLK, data_out);
    end

endmodule
