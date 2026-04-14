`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK0;
    reg CLK1;
    reg F13X;
    reg F17X;
    reg FCLK;
    reg INST;
    reg NPURST;
    reg NRUN;
    reg NSA;
    reg NSTEP;
    reg OUT8;
    reg SNI;
    wire STBY;
    wire [3:0] TPG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK0(CLK0),
        .CLK1(CLK1),
        .F13X(F13X),
        .F17X(F17X),
        .FCLK(FCLK),
        .INST(INST),
        .NPURST(NPURST),
        .NRUN(NRUN),
        .NSA(NSA),
        .NSTEP(NSTEP),
        .OUT8(OUT8),
        .SNI(SNI),
        .STBY(STBY),
        .TPG(TPG)
    );

    // Clock generation (10ns period)
    initial begin
        CLK1 = 0;
        forever #5 CLK1 = ~CLK1;
    end

        task reset_dut;

    begin
        NPURST = 0;
        CLK0 = 0;
        F13X = 0;
        F17X = 0;
        FCLK = 0;
        INST = 0;
        NRUN = 1;
        NSA = 1;
        NSTEP = 1;
        OUT8 = 0;
        SNI = 0;
        repeat(5) @(posedge CLK1);
        #1;
        NPURST = 1;
        repeat(2) @(posedge CLK1);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Reset", test_num);
        reset_dut();


        #1;



        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Run Mode Increment", test_num);
        reset_dut();

        NRUN = 0;
        NSA = 0;
        NSTEP = 1;


        repeat(5) @(posedge CLK1);
        #1;


        #1;



        check_outputs(1'b0, 4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pause Mode", test_num);
        reset_dut();

        NRUN = 0;
        NSA = 0;
        repeat(3) @(posedge CLK1);

        NRUN = 1;
        repeat(5) @(posedge CLK1);
        #1;


        #1;



        check_outputs(1'b1, 4'h3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Standby Control", test_num);
        reset_dut();

        NRUN = 0;
        NSA = 1;
        repeat(2) @(posedge CLK1);
        #1;


        #1;



        check_outputs(1'b1, 4'h2);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Wrap-around logic", test_num);
        reset_dut();

        NRUN = 0;
        NSA = 0;
        repeat(16) @(posedge CLK1);
        #1;


        #1;



        check_outputs(1'b0, 4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control Inputs F13X/F17X", test_num);
        reset_dut();

        NRUN = 0;
        NSA = 0;
        F13X = 1;
        F17X = 1;
        INST = 1;
        repeat(4) @(posedge CLK1);
        #1;


        #1;



        check_outputs(1'b0, 4'h4);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: NSTEP Single Pulse", test_num);
        reset_dut();

        NRUN = 1;
        NSA = 0;


        NSTEP = 0;
        @(posedge CLK1);
        #1;
        NSTEP = 1;
        repeat(2) @(posedge CLK1);
        #1;


        #1;



        check_outputs(1'b1, 4'h1);
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
        input expected_STBY;
        input [3:0] expected_TPG;
        begin
            if (expected_STBY === (expected_STBY ^ STBY ^ expected_STBY) &&
                expected_TPG === (expected_TPG ^ TPG ^ expected_TPG)) begin
                $display("PASS");
                $display("  Outputs: STBY=%b, TPG=%h",
                         STBY, TPG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: STBY=%b, TPG=%h",
                         expected_STBY, expected_TPG);
                $display("  Got:      STBY=%b, TPG=%h",
                         STBY, TPG);
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
        $dumpvars(0,CLK0, CLK1, F13X, F17X, FCLK, INST, NPURST, NRUN, NSA, NSTEP, OUT8, SNI, STBY, TPG);
    end

endmodule
