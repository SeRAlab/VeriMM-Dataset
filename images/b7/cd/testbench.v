`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CA;
    reg CLK;
    reg CLR;
    reg [3:0] D;
    reg LD;
    reg SEL;
    wire a;
    wire b;
    wire c;
    wire d;
    wire e;
    wire f;
    wire g;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CA(CA),
        .CLK(CLK),
        .CLR(CLR),
        .D(D),
        .LD(LD),
        .SEL(SEL),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CLR = 1;
            LD = 0;
            D = 4'b0000;
            CA = 0;
            SEL = 1;
            @(posedge CLK);
            #2 CLR = 0;
            $display("DUT Reset completed.");
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset state (Digit 0, Active High)");
            reset_dut();

            #1;
            #1;

            check_outputs(1, 1, 1, 1, 1, 1, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Load Hex 'A'");
            reset_dut();
            D = 4'hA;
            LD = 1;
            @(posedge CLK);
            #2 LD = 0;

            #1;


            check_outputs(1, 1, 1, 0, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Load Hex '1' with CA inversion");
            reset_dut();
            D = 4'h1;
            LD = 1;
            CA = 1;
            @(posedge CLK);
            #2 LD = 0;

            #1;


            check_outputs(1, 0, 0, 1, 1, 1, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Shifting bits (1 to 2)");
            reset_dut();
            D = 4'h1;
            LD = 1;
            @(posedge CLK);
            #2 LD = 0;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1, 1, 0, 1, 1, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: SEL signal control (Blanking)");
            reset_dut();
            D = 4'h8;
            LD = 1;
            SEL = 0;
            @(posedge CLK);
            #2 LD = 0;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Load Hex 'F'");
            reset_dut();
            D = 4'hF;
            LD = 1;
            CA = 0;
            SEL = 1;
            @(posedge CLK);
            #2 LD = 0;

            #1;


            check_outputs(1, 0, 0, 0, 1, 1, 1);
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
        input expected_a;
        input expected_b;
        input expected_c;
        input expected_d;
        input expected_e;
        input expected_f;
        input expected_g;
        begin
            if (expected_a === (expected_a ^ a ^ expected_a) &&
                expected_b === (expected_b ^ b ^ expected_b) &&
                expected_c === (expected_c ^ c ^ expected_c) &&
                expected_d === (expected_d ^ d ^ expected_d) &&
                expected_e === (expected_e ^ e ^ expected_e) &&
                expected_f === (expected_f ^ f ^ expected_f) &&
                expected_g === (expected_g ^ g ^ expected_g)) begin
                $display("PASS");
                $display("  Outputs: a=%b, b=%b, c=%b, d=%b, e=%b, f=%b, g=%b",
                         a, b, c, d, e, f, g);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%b, b=%b, c=%b, d=%b, e=%b, f=%b, g=%b",
                         expected_a, expected_b, expected_c, expected_d, expected_e, expected_f, expected_g);
                $display("  Got:      a=%b, b=%b, c=%b, d=%b, e=%b, f=%b, g=%b",
                         a, b, c, d, e, f, g);
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
        $dumpvars(0,CA, CLK, CLR, D, LD, SEL, a, b, c, d, e, f, g);
    end

endmodule
