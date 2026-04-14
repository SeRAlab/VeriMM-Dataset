`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] A;
    reg CK;
    reg [23:0] D;
    reg OE;
    reg WE;
    wire [23:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .CK(CK),
        .D(D),
        .OE(OE),
        .WE(WE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CK = 0;
        forever #5 CK = ~CK;
    end

        task reset_dut;

    begin
        A <= 16'h0;
        D <= 24'h0;
        WE <= 1'b0;
        OE <= 1'b0;
        @(posedge CK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();


        A <= 16'h1234;
        D <= 24'hABCDEF;
        WE <= 1'b1;
        OE <= 1'b0;
        @(posedge CK);
        #1;


        WE <= 1'b0;
        OE <= 1'b1;
        A <= 16'h1234;
        @(posedge CK);
        #1;

        $display("Testcase 001: Basic Write and Read");
        #1;

        check_outputs(24'hABCDEF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();


        A <= 16'h5555;
        D <= 24'hAAAAAA;
        WE <= 1'b1;
        @(posedge CK);
        #1;


        WE <= 1'b0;
        OE <= 1'b0;
        A <= 16'h5555;
        @(posedge CK);
        #1;

        $display("Testcase 002: OE Low Output Check");
        #1;

        check_outputs(24'h000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();


        A <= 16'h0001;
        D <= 24'hFFFFFF;
        WE <= 1'b0;
        @(posedge CK);
        #1;


        OE <= 1'b1;
        @(posedge CK);
        #1;

        $display("Testcase 003: WE Low Write Inhibit Check");
        #1;

        check_outputs(24'h000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();


        A <= 16'h000A;
        D <= 24'h111111;
        WE <= 1'b1;
        @(posedge CK);
        #1;


        A <= 16'h000B;
        D <= 24'h222222;
        WE <= 1'b1;
        @(posedge CK);
        #1;


        WE <= 1'b0;
        OE <= 1'b1;
        A <= 16'h000A;
        @(posedge CK);
        #1;

        $display("Testcase 004: Persistence and Address Independence");
        #1;

        check_outputs(24'h111111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();


        A <= 16'h0010;
        D <= 24'h666666;
        WE <= 1'b1;
        @(posedge CK);
        #1;


        A <= 16'h0010;
        OE <= 1'b1;
        WE <= 1'b1;
        D <= 24'h777777;



        @(posedge CK);
        #1;

        $display("Testcase 005: Reading while Writing");


        #1;



        check_outputs(24'h666666);
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
        input [23:0] expected_Q;
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
        $dumpvars(0,A, CK, D, OE, WE, Q);
    end

endmodule
