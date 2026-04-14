`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] DATA;
    reg EN;
    reg TE;
    wire [31:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA(DATA),
        .EN(EN),
        .TE(TE),
        .Q(Q)
    );

        task reset_dut;

    begin
        CLK = 0;
        EN = 1;
        TE = 0;
        DATA = 32'h0;
        #10;
        CLK = 1;
        #10;
        CLK = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase 001: Basic data capture (EN=1, TE=0)");

        DATA = 32'hDEADBEEF;
        EN = 1;
        TE = 0;
        #10;
        CLK = 1;
        #10;
        CLK = 0;
        #10;

        #1;


        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase 002: Verify clock is gated when EN=0");


        DATA = 32'h11112222;
        EN = 1;
        TE = 0;
        #10 CLK = 1; #10 CLK = 0; #10;


        DATA = 32'hFFFFFFFF;
        EN = 0;
        TE = 0;
        #10 CLK = 1; #10 CLK = 0; #10;


        #1;



        check_outputs(32'h11112222);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase 003: Verify clock is gated when TE=1");


        DATA = 32'hAAAA5555;
        EN = 1;
        TE = 0;
        #10 CLK = 1; #10 CLK = 0; #10;


        DATA = 32'h00000000;
        EN = 1;
        TE = 1;
        #10 CLK = 1; #10 CLK = 0; #10;


        #1;



        check_outputs(32'hAAAA5555);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase 004: Verify clock is gated when EN=0 and TE=1");


        DATA = 32'h12345678;
        EN = 1;
        TE = 0;
        #10 CLK = 1; #10 CLK = 0; #10;


        DATA = 32'h87654321;
        EN = 0;
        TE = 1;
        #10 CLK = 1; #10 CLK = 0; #10;

        #1;


        check_outputs(32'h12345678);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase 005: Multiple sequential updates with clock enabled");

        EN = 1;
        TE = 0;

        DATA = 32'h00000001;
        #10 CLK = 1; #10 CLK = 0; #10;

        DATA = 32'h00000002;
        #10 CLK = 1; #10 CLK = 0; #10;

        DATA = 32'h00000004;
        #10 CLK = 1; #10 CLK = 0; #10;

        #1;


        check_outputs(32'h00000004);
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
        input [31:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,CLK, DATA, EN, TE, Q);
    end

endmodule
