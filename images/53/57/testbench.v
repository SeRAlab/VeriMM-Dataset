`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg [127:0] i_datain;
    reg [3:0] i_datain_valid;
    reg i_dataout_stall;
    reg [2:0] i_settings;
    reg i_start;
    reg resetn;
    wire [3:0] o_datain_stall;
    wire [31:0] o_dataout;
    wire o_dataout_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .i_datain(i_datain),
        .i_datain_valid(i_datain_valid),
        .i_dataout_stall(i_dataout_stall),
        .i_settings(i_settings),
        .i_start(i_start),
        .resetn(resetn),
        .o_datain_stall(o_datain_stall),
        .o_dataout(o_dataout),
        .o_dataout_valid(o_dataout_valid)
    );
    task testcase001;

        begin
            $display("Running Testcase 001: Simple Mode (OR Aggregation)");
            reset_dut();

            i_settings = 3'b000;
            i_start = 1;
            i_datain_valid = 4'b0011;
            i_datain[31:0]  = 32'hAAAA_AAAA;
            i_datain[63:32] = 32'h5555_5555;
            i_datain[95:64] = 32'h0000_0000;
            i_datain[127:96]= 32'h0000_0000;

            @(posedge clock);
            #1;

            #1;


            check_outputs(4'b0000, 32'hFFFF_FFFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Configurable Mode (Select Input 0)");
            reset_dut();

            i_settings = 3'b100;
            i_start = 1;
            i_datain_valid = 4'b1111;
            i_datain[31:0]  = 32'h1234_5678;
            i_datain[63:32] = 32'hAAAA_BBBB;

            @(posedge clock);
            #1;
            #1;

            check_outputs(4'b0000, 32'h1234_5678, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Configurable Mode (Select Input 3)");
            reset_dut();

            i_settings = 3'b111;
            i_start = 1;
            i_datain_valid = 4'b1000;
            i_datain[127:96] = 32'hDEAD_BEEF;

            @(posedge clock);
            #1;
            #1;

            check_outputs(4'b0000, 32'hDEAD_BEEF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Stall Propagation");
            reset_dut();

            i_settings = 3'b000;
            i_start = 1;
            i_dataout_stall = 1;
            i_datain_valid = 4'b1111;

            @(posedge clock);
            #1;

            #1;


            check_outputs(4'b1111, 32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Input Invalid Logic");
            reset_dut();

            i_settings = 3'b000;
            i_start = 0;
            i_datain_valid = 4'b1111;

            @(posedge clock);
            #1;
            #1;

            check_outputs(4'b0000, 32'h0, 1'b0);
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
        input [3:0] expected_o_datain_stall;
        input [31:0] expected_o_dataout;
        input expected_o_dataout_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_datain_stall === (expected_o_datain_stall ^ o_datain_stall ^ expected_o_datain_stall) &&
                expected_o_dataout === (expected_o_dataout ^ o_dataout ^ expected_o_dataout) &&
                expected_o_dataout_valid === (expected_o_dataout_valid ^ o_dataout_valid ^ expected_o_dataout_valid)) begin
                $display("PASS");
                $display("  Outputs: o_datain_stall=%h, o_dataout=%h, o_dataout_valid=%b",
                         o_datain_stall, o_dataout, o_dataout_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_datain_stall=%h, o_dataout=%h, o_dataout_valid=%b",
                         expected_o_datain_stall, expected_o_dataout, expected_o_dataout_valid);
                $display("  Got:      o_datain_stall=%h, o_dataout=%h, o_dataout_valid=%b",
                         o_datain_stall, o_dataout, o_dataout_valid);
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

endmodule
