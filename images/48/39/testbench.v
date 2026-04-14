`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg [31:0] i_datain;
    reg i_datain_valid;
    reg [1:0] i_dataout_stall;
    reg resetn;
    wire o_datain_stall;
    wire [31:0] o_dataout;
    wire [1:0] o_dataout_valid;

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
        .resetn(resetn),
        .o_datain_stall(o_datain_stall),
        .o_dataout(o_dataout),
        .o_dataout_valid(o_dataout_valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State", test_num);
            resetn = 0;
            i_datain = 32'hAAAAAAAA;
            i_datain_valid = 1'b1;
            i_dataout_stall = 2'b00;
            @(posedge clock);
            #1;

            #1;


            check_outputs(o_datain_stall, 32'h0, 2'b00);
            resetn = 1;
            @(posedge clock);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Forwarding (No Stalls)", test_num);
            resetn = 0; @(posedge clock); resetn = 1; @(posedge clock);

            i_datain = 32'hDEADBEEF;
            i_datain_valid = 1'b1;
            i_dataout_stall = 2'b00;

            @(posedge clock);

            #1;


            check_outputs(1'b0, 32'hDEADBEEF, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Downstream Stall Channel 0", test_num);
            resetn = 0; @(posedge clock); resetn = 1; @(posedge clock);

            i_datain = 32'h12345678;
            i_datain_valid = 1'b1;
            i_dataout_stall = 2'b01;

            @(posedge clock);

            #1;


            check_outputs(1'b1, 32'h12345678, 2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Downstream Stall Channel 1", test_num);
            resetn = 0; @(posedge clock); resetn = 1; @(posedge clock);

            i_datain = 32'h87654321;
            i_datain_valid = 1'b1;
            i_dataout_stall = 2'b10;

            @(posedge clock);
            #1;

            check_outputs(1'b1, 32'h87654321, 2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Both Channels Stalled", test_num);
            resetn = 0; @(posedge clock); resetn = 1; @(posedge clock);

            i_datain = 32'hFFFFFFFF;
            i_datain_valid = 1'b1;
            i_dataout_stall = 2'b11;

            @(posedge clock);
            #1;

            check_outputs(1'b1, 32'hFFFFFFFF, 2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input Not Valid", test_num);
            resetn = 0; @(posedge clock); resetn = 1; @(posedge clock);

            i_datain = 32'hCAFECAFE;
            i_datain_valid = 1'b0;
            i_dataout_stall = 2'b00;

            @(posedge clock);

            #1;


            check_outputs(1'b0, o_dataout, 2'b00);
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
        input [31:0] expected_o_dataout;
        input [1:0] expected_o_dataout_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_datain_stall === (expected_o_datain_stall ^ o_datain_stall ^ expected_o_datain_stall) &&
                expected_o_dataout === (expected_o_dataout ^ o_dataout ^ expected_o_dataout) &&
                expected_o_dataout_valid === (expected_o_dataout_valid ^ o_dataout_valid ^ expected_o_dataout_valid)) begin
                $display("PASS");
                $display("  Outputs: o_datain_stall=%b, o_dataout=%h, o_dataout_valid=%h",
                         o_datain_stall, o_dataout, o_dataout_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_datain_stall=%b, o_dataout=%h, o_dataout_valid=%h",
                         expected_o_datain_stall, expected_o_dataout, expected_o_dataout_valid);
                $display("  Got:      o_datain_stall=%b, o_dataout=%h, o_dataout_valid=%h",
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
