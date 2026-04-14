`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg clk;
    wire z0;
    wire z1;
    wire z2;
    wire z3;
    wire z4;
    wire z5;
    wire z6;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .z0(z0),
        .z1(z1),
        .z2(z2),
        .z3(z3),
        .z4(z4),
        .z5(z5),
        .z6(z6)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: a=0, b=0");
            reset_dut();
            a = 0; b = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'bx, 1'b0, 1'b0, 1'b0, 1'bx, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: a=0, b=1");
            reset_dut();
            a = 0; b = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'bx, 1'b0, 1'b0, 1'bx, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: a=1, b=0");
            reset_dut();
            a = 1; b = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'bx, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: a=1, b=1 (z0 capture)");
            reset_dut();
            a = 1; b = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 1'bx, 1'bx, 1'b0, 1'bx, 1'b1, 1'b1);
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
        input expected_z0;
        input expected_z1;
        input expected_z2;
        input expected_z3;
        input expected_z4;
        input expected_z5;
        input expected_z6;
        begin
            if (expected_z0 === (expected_z0 ^ z0 ^ expected_z0) &&
                expected_z1 === (expected_z1 ^ z1 ^ expected_z1) &&
                expected_z2 === (expected_z2 ^ z2 ^ expected_z2) &&
                expected_z3 === (expected_z3 ^ z3 ^ expected_z3) &&
                expected_z4 === (expected_z4 ^ z4 ^ expected_z4) &&
                expected_z5 === (expected_z5 ^ z5 ^ expected_z5) &&
                expected_z6 === (expected_z6 ^ z6 ^ expected_z6)) begin
                $display("PASS");
                $display("  Outputs: z0=%b, z1=%b, z2=%b, z3=%b, z4=%b, z5=%b, z6=%b",
                         z0, z1, z2, z3, z4, z5, z6);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z0=%b, z1=%b, z2=%b, z3=%b, z4=%b, z5=%b, z6=%b",
                         expected_z0, expected_z1, expected_z2, expected_z3, expected_z4, expected_z5, expected_z6);
                $display("  Got:      z0=%b, z1=%b, z2=%b, z3=%b, z4=%b, z5=%b, z6=%b",
                         z0, z1, z2, z3, z4, z5, z6);
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
        $dumpvars(0,a, b, clk, z0, z1, z2, z3, z4, z5, z6);
    end

endmodule
