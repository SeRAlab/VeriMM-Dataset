`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg [31:0] i_datain;
    reg i_datain_valid;
    reg i_dataout_stall;
    reg reset;
    wire o_datain_stall;
    wire [63:0] o_dataout;
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
        .reset(reset),
        .o_datain_stall(o_datain_stall),
        .o_dataout(o_dataout),
        .o_dataout_valid(o_dataout_valid)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Basic 32-bit zero extension", test_num);
            reset = 1;
            i_datain = 32'h0;
            i_datain_valid = 0;
            i_dataout_stall = 0;
            #20 reset = 0;
            @(posedge clock);
            i_datain = 32'h12345678;
            i_datain_valid = 1'b1;
            i_dataout_stall = 1'b0;
            @(posedge clock);
            #1;

            check_outputs(1'b0, 64'h0000000012345678, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Maximum 32-bit value extension", test_num);
            reset = 1;
            #20 reset = 0;
            @(posedge clock);
            i_datain = 32'hFFFFFFFF;
            i_datain_valid = 1'b1;
            i_dataout_stall = 1'b0;
            @(posedge clock);
            #1;

            check_outputs(1'b0, 64'h00000000FFFFFFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Valid bit propagation (i_datain_valid = 0)", test_num);
            reset = 1;
            #20 reset = 0;
            @(posedge clock);
            i_datain = 32'hA5A5A5A5;
            i_datain_valid = 1'b0;
            i_dataout_stall = 1'b0;
            @(posedge clock);
            #1;

            check_outputs(1'b0, 64'h00000000A5A5A5A5, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Stall signal propagation (i_dataout_stall = 1)", test_num);
            reset = 1;
            #20 reset = 0;
            @(posedge clock);
            i_datain = 32'h5A5A5A5A;
            i_datain_valid = 1'b1;
            i_dataout_stall = 1'b1;
            @(posedge clock);
            #1;

            check_outputs(1'b1, 64'h000000005A5A5A5A, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Zero input data", test_num);
            reset = 1;
            #20 reset = 0;
            @(posedge clock);
            i_datain = 32'h00000000;
            i_datain_valid = 1'b1;
            i_dataout_stall = 1'b0;
            @(posedge clock);
            #1;

            check_outputs(1'b0, 64'h0000000000000000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Alternating pattern with stall and valid high", test_num);
            reset = 1;
            #20 reset = 0;
            @(posedge clock);
            i_datain = 32'hDEADBEEF;
            i_datain_valid = 1'b1;
            i_dataout_stall = 1'b1;
            @(posedge clock);
            #1;

            check_outputs(1'b1, 64'h00000000DEADBEEF, 1'b1);
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
        input expected_o_datain_stall;
        input [63:0] expected_o_dataout;
        input expected_o_dataout_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_datain_stall === (expected_o_datain_stall ^ o_datain_stall ^ expected_o_datain_stall) &&
                expected_o_dataout === (expected_o_dataout ^ o_dataout ^ expected_o_dataout) &&
                expected_o_dataout_valid === (expected_o_dataout_valid ^ o_dataout_valid ^ expected_o_dataout_valid)) begin
                $display("PASS");
                $display("  Outputs: o_datain_stall=%b, o_dataout=%h, o_dataout_valid=%b",
                         o_datain_stall, o_dataout, o_dataout_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_datain_stall=%b, o_dataout=%h, o_dataout_valid=%b",
                         expected_o_datain_stall, expected_o_dataout, expected_o_dataout_valid);
                $display("  Got:      o_datain_stall=%b, o_dataout=%h, o_dataout_valid=%b",
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
