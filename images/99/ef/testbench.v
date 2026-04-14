`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg [13:0] B;
    reg CE;
    reg CLK;
    reg SCLR;
    wire [53:0] P;
    wire [47:0] PCASC;
    wire [1:0] ZERO_DETECT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CE(CE),
        .CLK(CLK),
        .SCLR(SCLR),
        .P(P),
        .PCASC(PCASC),
        .ZERO_DETECT(ZERO_DETECT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        SCLR = 1;
        CE = 0;
        A = 0;
        B = 0;
        @(posedge CLK);
        #1;
        SCLR = 0;
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Synchronous Clear (SCLR)", test_num);
        reset_dut();


        #1;



        check_outputs(54'h0, 48'h0, 2'b00);
    end
        endtask

    task testcase002;

    reg [53:0] expected_p;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Multiplication (100 * 50)", test_num);
        reset_dut();
        A = 32'd100;
        B = 14'd50;
        CE = 1;
        SCLR = 0;
        @(posedge CLK);
        #2;
        expected_p = 54'd5000;

        #1;


        check_outputs(expected_p, expected_p[47:0], (expected_p == 0) ? 2'b11 : 2'b00);
    end
        endtask

    task testcase003;

    reg [53:0] expected_p;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large Values Multiplication", test_num);
        reset_dut();
        A = 32'hFFFF_FFFF;
        B = 14'h3FFF;
        CE = 1;
        SCLR = 0;
        @(posedge CLK);
        #2;
        expected_p = 54'hFFFF_FFFF * 54'h3FFF;
        #1;

        check_outputs(expected_p, expected_p[47:0], (expected_p == 0) ? 2'b11 : 2'b00);
    end
        endtask

    task testcase004;

    reg [53:0] initial_p;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Clock Enable (CE) functionality", test_num);
        reset_dut();


        A = 32'd10;
        B = 14'd10;
        CE = 1;
        @(posedge CLK);
        #2;
        initial_p = P;


        A = 32'd20;
        B = 14'd20;
        CE = 0;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(initial_p, initial_p[47:0], (initial_p == 0) ? 2'b11 : 2'b00);
    end
        endtask

    task testcase005;

    reg [53:0] expected_p;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication by Zero", test_num);
        reset_dut();
        A = 32'h12345678;
        B = 14'd0;
        CE = 1;
        @(posedge CLK);
        #2;
        expected_p = 54'd0;

        #1;


        check_outputs(expected_p, 48'h0, 2'b11);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SCLR Priority Over CE", test_num);
        reset_dut();
        A = 32'h5555_5555;
        B = 14'h1234;
        CE = 1;
        SCLR = 1;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(54'h0, 48'h0, 2'b00);
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
        input [53:0] expected_P;
        input [47:0] expected_PCASC;
        input [1:0] expected_ZERO_DETECT;
        begin
            if (expected_P === (expected_P ^ P ^ expected_P) &&
                expected_PCASC === (expected_PCASC ^ PCASC ^ expected_PCASC) &&
                expected_ZERO_DETECT === (expected_ZERO_DETECT ^ ZERO_DETECT ^ expected_ZERO_DETECT)) begin
                $display("PASS");
                $display("  Outputs: P=%h, PCASC=%h, ZERO_DETECT=%h",
                         P, PCASC, ZERO_DETECT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h, PCASC=%h, ZERO_DETECT=%h",
                         expected_P, expected_PCASC, expected_ZERO_DETECT);
                $display("  Got:      P=%h, PCASC=%h, ZERO_DETECT=%h",
                         P, PCASC, ZERO_DETECT);
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
        $dumpvars(0,A, B, CE, CLK, SCLR, P, PCASC, ZERO_DETECT);
    end

endmodule
