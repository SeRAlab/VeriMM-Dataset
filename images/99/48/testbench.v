`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] A0;
    reg [9:0] A1;
    reg CE0;
    reg CE1;
    reg CLK;
    reg [31:0] D0;
    reg [31:0] D1;
    reg WE0;
    reg WE1;
    reg [31:0] WEM0;
    reg [31:0] WEM1;
    wire [31:0] Q0;
    wire [31:0] Q1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A0(A0),
        .A1(A1),
        .CE0(CE0),
        .CE1(CE1),
        .CLK(CLK),
        .D0(D0),
        .D1(D1),
        .WE0(WE0),
        .WE1(WE1),
        .WEM0(WEM0),
        .WEM1(WEM1),
        .Q0(Q0),
        .Q1(Q1)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        A0 = 0;
        A1 = 0;
        CE0 = 0;
        CE1 = 0;
        D0 = 0;
        D1 = 0;
        WE0 = 0;
        WE1 = 0;
        WEM0 = 32'hFFFFFFFF;
        WEM1 = 32'hFFFFFFFF;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Port 0 Basic Write/Read", test_num);
        reset_dut();


        CE0 = 1; WE0 = 1; A0 = 10'h010; D0 = 32'hDEADBEEF; WEM0 = 32'hFFFFFFFF;
        @(posedge CLK);
        #1;


        WE0 = 0;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(32'hDEADBEEF, 32'hxxxxxxxx);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Port 1 Basic Write/Read", test_num);
        reset_dut();


        CE1 = 1; WE1 = 1; A1 = 10'h3FF; D1 = 32'hCAFEBABE; WEM1 = 32'hFFFFFFFF;
        @(posedge CLK);
        #1;


        WE1 = 0;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(32'hxxxxxxxx, 32'hCAFEBABE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Port 0 Masked Write", test_num);
        reset_dut();


        CE0 = 1; WE0 = 1; A0 = 10'h005; D0 = 32'hFFFFFFFF; WEM0 = 32'hFFFFFFFF;
        @(posedge CLK);
        #1;



        D0 = 32'h00000000; WEM0 = 32'h0000FFFF;
        @(posedge CLK);
        #1;


        WE0 = 0;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(32'hFFFF0000, 32'hxxxxxxxx);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Parallel Dual-Port Write", test_num);
        reset_dut();


        CE0 = 1; WE0 = 1; A0 = 10'h100; D0 = 32'h11111111;
        CE1 = 1; WE1 = 1; A1 = 10'h200; D1 = 32'h22222222;
        @(posedge CLK);
        #1;


        WE0 = 0; WE1 = 0;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(32'h11111111, 32'h22222222);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Boundary Address and CE Toggle", test_num);
        reset_dut();


        CE0 = 1; WE0 = 1; A0 = 10'h000; D0 = 32'h55AA55AA;
        @(posedge CLK);
        #1;


        CE0 = 0; WE0 = 0;
        @(posedge CLK);
        #1;



        CE0 = 1;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(32'h55AA55AA, 32'hxxxxxxxx);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Dual Port Simultaneous Read", test_num);
        reset_dut();


        CE0 = 1; WE0 = 1; A0 = 10'h0AB; D0 = 32'h99887766;
        @(posedge CLK);
        #1;


        WE0 = 0; A0 = 10'h0AB;
        CE1 = 1; WE1 = 0; A1 = 10'h0AB;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(32'h99887766, 32'h99887766);
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
        input [31:0] expected_Q0;
        input [31:0] expected_Q1;
        begin
            if (expected_Q0 === (expected_Q0 ^ Q0 ^ expected_Q0) &&
                expected_Q1 === (expected_Q1 ^ Q1 ^ expected_Q1)) begin
                $display("PASS");
                $display("  Outputs: Q0=%h, Q1=%h",
                         Q0, Q1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q0=%h, Q1=%h",
                         expected_Q0, expected_Q1);
                $display("  Got:      Q0=%h, Q1=%h",
                         Q0, Q1);
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
        $dumpvars(0,A0, A1, CE0, CE1, CLK, D0, D1, WE0, WE1, WEM0, WEM1, Q0, Q1);
    end

endmodule
