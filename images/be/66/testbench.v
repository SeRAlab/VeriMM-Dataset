`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [17:0] A;
    reg [17:0] B;
    reg [17:0] C;
    reg CEA;
    reg CEB;
    reg CEC;
    reg CEOUT;
    reg CLK;
    reg RSTA;
    reg RSTB;
    reg RSTC;
    reg RSTOUT;
    reg SIGNEDA;
    reg SIGNEDB;
    reg SIGNEDC;
    wire [35:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .CEA(CEA),
        .CEB(CEB),
        .CEC(CEC),
        .CEOUT(CEOUT),
        .CLK(CLK),
        .RSTA(RSTA),
        .RSTB(RSTB),
        .RSTC(RSTC),
        .RSTOUT(RSTOUT),
        .SIGNEDA(SIGNEDA),
        .SIGNEDB(SIGNEDB),
        .SIGNEDC(SIGNEDC),
        .Z(Z)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RSTA = 1; RSTB = 1; RSTC = 1; RSTOUT = 1;
        CEA = 0; CEB = 0; CEC = 0; CEOUT = 0;
        SIGNEDA = 0; SIGNEDB = 0; SIGNEDC = 0;
        A = 0; B = 0; C = 0;
        @(posedge CLK);
        #1;
        RSTA = 0; RSTB = 0; RSTC = 0; RSTOUT = 0;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test Case 001: Unsigned 10 * 20 + 5");
        A = 18'd10; B = 18'd20; C = 18'd5;
        SIGNEDA = 0; SIGNEDB = 0; SIGNEDC = 0;
        CEA = 1; CEB = 1; CEC = 1; CEOUT = 1;
        @(posedge CLK);
        #1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(calc_expected(10, 20, 5, 0, 0, 0));
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test Case 002: Signed A (-5) * Unsigned B (10) + C (2)");
        A = -18'd5; B = 18'd10; C = 18'd2;
        SIGNEDA = 1; SIGNEDB = 0; SIGNEDC = 0;
        CEA = 1; CEB = 1; CEC = 1; CEOUT = 1;
        @(posedge CLK);
        #1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(calc_expected(A, B, C, 1, 0, 0));
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test Case 003: All Signed (-100 * 2 + -50)");
        A = -18'd100; B = 18'd2; C = -18'd50;
        SIGNEDA = 1; SIGNEDB = 1; SIGNEDC = 1;
        CEA = 1; CEB = 1; CEC = 1; CEOUT = 1;
        @(posedge CLK);
        #1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(calc_expected(A, B, C, 1, 1, 1));
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test Case 004: Max Unsigned Values");
        A = 18'h3FFFF; B = 18'h3FFFF; C = 18'h3FFFF;
        SIGNEDA = 0; SIGNEDB = 0; SIGNEDC = 0;
        CEA = 1; CEB = 1; CEC = 1; CEOUT = 1;
        @(posedge CLK);
        #1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(calc_expected(A, B, C, 0, 0, 0));
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test Case 005: Min Signed A (-131072) * -1 + 0");
        A = 18'h20000;
        B = -18'd1;
        C = 18'd0;
        SIGNEDA = 1; SIGNEDB = 1; SIGNEDC = 1;
        CEA = 1; CEB = 1; CEC = 1; CEOUT = 1;
        @(posedge CLK);
        #1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(calc_expected(A, B, C, 1, 1, 1));
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test Case 006: Output Reset (RSTOUT)");
        A = 18'd50; B = 18'd50; C = 18'd50;
        SIGNEDA = 0; SIGNEDB = 0; SIGNEDC = 0;
        CEA = 1; CEB = 1; CEC = 1; CEOUT = 1;
        @(posedge CLK);
        #1;
        RSTOUT = 1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(36'd0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Test Case 007: Clock Enable CEOUT (Disable update)");

        A = 18'd10; B = 18'd10; C = 18'd0;
        CEA = 1; CEB = 1; CEC = 1; CEOUT = 1;
        @(posedge CLK); #1;
        @(posedge CLK); #1;


        A = 18'd20; B = 18'd20; CEOUT = 0;
        @(posedge CLK); #1;
        @(posedge CLK); #1;
        #1;

        check_outputs(36'd100);
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
        input [35:0] expected_Z;
        begin
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
        $dumpvars(0,A, B, C, CEA, CEB, CEC, CEOUT, CLK, RSTA, RSTB, RSTC, RSTOUT, SIGNEDA, SIGNEDB, SIGNEDC, Z);
    end

endmodule
