`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg [31:0] i_dataa;
    reg i_dataa_valid;
    reg [31:0] i_datab;
    reg i_datab_valid;
    reg i_dataouta_stall;
    reg i_dataoutb_stall;
    reg [31:0] i_register_settings;
    reg [1:0] i_settings;
    reg resetn;
    wire o_dataa_stall;
    wire o_datab_stall;
    wire [31:0] o_dataouta;
    wire o_dataouta_valid;
    wire [31:0] o_dataoutb;
    wire o_dataoutb_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .i_dataa(i_dataa),
        .i_dataa_valid(i_dataa_valid),
        .i_datab(i_datab),
        .i_datab_valid(i_datab_valid),
        .i_dataouta_stall(i_dataouta_stall),
        .i_dataoutb_stall(i_dataoutb_stall),
        .i_register_settings(i_register_settings),
        .i_settings(i_settings),
        .resetn(resetn),
        .o_dataa_stall(o_dataa_stall),
        .o_datab_stall(o_datab_stall),
        .o_dataouta(o_dataouta),
        .o_dataouta_valid(o_dataouta_valid),
        .o_dataoutb(o_dataoutb),
        .o_dataoutb_valid(o_dataoutb_valid)
    );
    task testcase001;

        begin
            $display("Test Case 001: Normal Operation - No Bypass");
            resetn = 0;
            i_settings = 2'b00; i_dataouta_stall = 0; i_dataoutb_stall = 0;
            i_dataa = 32'h1111_1111; i_dataa_valid = 1;
            i_datab = 32'h2222_2222; i_datab_valid = 1;
            @(posedge clock); #1; resetn = 1;
            @(posedge clock); #2;
            #1;

            check_outputs(1'b0, 1'b0, 32'h1111_1111, 1'b1, 32'h2222_2222, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Path A Bypass");
            resetn = 0;
            i_settings = 2'b01;
            i_register_settings = 32'hAAAA_AAAA;
            i_dataa = 32'h1234_5678; i_dataa_valid = 1;
            i_datab = 32'h8765_4321; i_datab_valid = 1;
            i_dataouta_stall = 0; i_dataoutb_stall = 0;
            @(posedge clock); #1; resetn = 1;
            @(posedge clock); #2;
            #1;

            check_outputs(1'b0, 1'b0, 32'hAAAA_AAAA, 1'b1, 32'h8765_4321, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Path B Bypass");
            resetn = 0;
            i_settings = 2'b10;
            i_register_settings = 32'hBBBB_BBBB;
            i_dataa = 32'h1111_1111; i_dataa_valid = 1;
            i_datab = 32'h2222_2222; i_datab_valid = 1;
            i_dataouta_stall = 0; i_dataoutb_stall = 0;
            @(posedge clock); #1; resetn = 1;
            @(posedge clock); #2;
            #1;

            check_outputs(1'b0, 1'b0, 32'h1111_1111, 1'b1, 32'hBBBB_BBBB, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Both Paths Bypassed");
            resetn = 0;
            i_settings = 2'b11;
            i_register_settings = 32'hCCCC_CCCC;
            i_dataouta_stall = 0; i_dataoutb_stall = 0;
            @(posedge clock); #1; resetn = 1;
            @(posedge clock); #2;
            #1;

            check_outputs(1'b0, 1'b0, 32'hCCCC_CCCC, 1'b1, 32'hCCCC_CCCC, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Valid Signal Propagation (No valid input)");
            resetn = 0;
            i_settings = 2'b00;
            i_dataa_valid = 0; i_datab_valid = 0;
            i_dataouta_stall = 0; i_dataoutb_stall = 0;
            @(posedge clock); #1; resetn = 1;
            @(posedge clock); #2;
            #1;

            check_outputs(1'b0, 1'b0, 32'h0, 1'b0, 32'h0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Stall Signal Propagation");
            resetn = 0;
            i_settings = 2'b00;
            i_dataouta_stall = 1;
            i_dataoutb_stall = 0;
            i_dataa = 32'hFFFF_FFFF; i_dataa_valid = 1;
            @(posedge clock); #1; resetn = 1;
            @(posedge clock); #2;

            #1;


            check_outputs(1'b1, 1'b0, 32'hFFFF_FFFF, 1'b1, 32'h0, 1'b0);
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
        input expected_o_dataa_stall;
        input expected_o_datab_stall;
        input [31:0] expected_o_dataouta;
        input expected_o_dataouta_valid;
        input [31:0] expected_o_dataoutb;
        input expected_o_dataoutb_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_dataa_stall === (expected_o_dataa_stall ^ o_dataa_stall ^ expected_o_dataa_stall) &&
                expected_o_datab_stall === (expected_o_datab_stall ^ o_datab_stall ^ expected_o_datab_stall) &&
                expected_o_dataouta === (expected_o_dataouta ^ o_dataouta ^ expected_o_dataouta) &&
                expected_o_dataouta_valid === (expected_o_dataouta_valid ^ o_dataouta_valid ^ expected_o_dataouta_valid) &&
                expected_o_dataoutb === (expected_o_dataoutb ^ o_dataoutb ^ expected_o_dataoutb) &&
                expected_o_dataoutb_valid === (expected_o_dataoutb_valid ^ o_dataoutb_valid ^ expected_o_dataoutb_valid)) begin
                $display("PASS");
                $display("  Outputs: o_dataa_stall=%b, o_datab_stall=%b, o_dataouta=%h, o_dataouta_valid=%b, o_dataoutb=%h, o_dataoutb_valid=%b",
                         o_dataa_stall, o_datab_stall, o_dataouta, o_dataouta_valid, o_dataoutb, o_dataoutb_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_dataa_stall=%b, o_datab_stall=%b, o_dataouta=%h, o_dataouta_valid=%b, o_dataoutb=%h, o_dataoutb_valid=%b",
                         expected_o_dataa_stall, expected_o_datab_stall, expected_o_dataouta, expected_o_dataouta_valid, expected_o_dataoutb, expected_o_dataoutb_valid);
                $display("  Got:      o_dataa_stall=%b, o_datab_stall=%b, o_dataouta=%h, o_dataouta_valid=%b, o_dataoutb=%h, o_dataoutb_valid=%b",
                         o_dataa_stall, o_datab_stall, o_dataouta, o_dataouta_valid, o_dataoutb, o_dataoutb_valid);
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
