`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] alu_in;
    reg [15:0] cntrl_in;
    reg [15:0] mem_in;
    reg [1:0] sel;
    wire [15:0] mux16_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_in(alu_in),
        .cntrl_in(cntrl_in),
        .mem_in(mem_in),
        .sel(sel),
        .mux16_out(mux16_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Select alu_in (sel=00)");
        alu_in = 16'hAAAA;
        mem_in = 16'h5555;
        cntrl_in = 16'h1234;
        sel = 2'b00;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Select mem_in (sel=01)");
        alu_in = 16'hAAAA;
        mem_in = 16'h5555;
        cntrl_in = 16'h1234;
        sel = 2'b01;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Select cntrl_in (sel=10)");
        alu_in = 16'hAAAA;
        mem_in = 16'h5555;
        cntrl_in = 16'h1234;
        sel = 2'b10;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Select 11 (Expected 0)");
        alu_in = 16'hFFFF;
        mem_in = 16'hFFFF;
        cntrl_in = 16'hFFFF;
        sel = 2'b11;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Zero check");
        alu_in = 16'h0000;
        mem_in = 16'hFFFF;
        cntrl_in = 16'hFFFF;
        sel = 2'b00;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Bit toggle check");
        alu_in = 16'h0000;
        mem_in = 16'hFFFF;
        cntrl_in = 16'h0000;
        sel = 2'b01;
        #1;

        check_outputs(16'hFFFF);
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
        input [15:0] expected_mux16_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux16_out === (expected_mux16_out ^ mux16_out ^ expected_mux16_out)) begin
                $display("PASS");
                $display("  Outputs: mux16_out=%h",
                         mux16_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux16_out=%h",
                         expected_mux16_out);
                $display("  Got:      mux16_out=%h",
                         mux16_out);
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
