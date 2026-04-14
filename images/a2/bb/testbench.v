`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg C;
    reg S;
    reg clk;
    reg enable;
    wire Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .S(S),
        .clk(clk),
        .enable(enable),
        .Z(Z)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 1;
            S = 0;
            A = 0; B = 0; C = 0;
            repeat (8) @(posedge clk);
            #1;
        end
        endtask
    task shift_bit;

        input bit_val;
        begin
            S = bit_val;
            enable = 1;
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            S = 1; enable = 1;
            @(posedge clk);
            S = 0; enable = 1;
            @(posedge clk);
            enable = 0;
            {A, B, C} = 3'b000;
            #2;
            $display("Testcase %0d: Basic shift check (Index 0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();

            S = 1; enable = 1;
            @(posedge clk);

            S = 0;
            repeat(7) @(posedge clk);
            enable = 0;
            {A, B, C} = 3'b111;
            #2;
            $display("Testcase %0d: Access oldest bit (Index 7)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            S = 1; enable = 1;
            @(posedge clk);
            S = 0; enable = 0;
            @(posedge clk);
            @(posedge clk);
            {A, B, C} = 3'b000;
            #2;
            $display("Testcase %0d: Enable signal check", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            shift_bit(1); shift_bit(1); shift_bit(0); shift_bit(1);
            shift_bit(0); shift_bit(0); shift_bit(1); shift_bit(0);

            enable = 0;
            {A, B, C} = 3'b110;
            #2;
            $display("Testcase %0d: Full pattern check (Index 6)", test_num);
            #1;

            check_outputs(1'b1);
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
        input expected_Z;
        begin
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%b",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%b",
                         expected_Z);
                $display("  Got:      Z=%b",
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
        $dumpvars(0,A, B, C, S, clk, enable, Z);
    end

endmodule
