`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CARRY_IN;
    reg CLK;
    reg LOAD;
    reg [2:0] LOAD_VAL;
    reg UP_DOWN;
    reg [3:0] a;
    reg [3:0] b;
    reg sub;
    wire [3:0] Q;
    wire [2:0] counter_out;
    wire cout;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CARRY_IN(CARRY_IN),
        .CLK(CLK),
        .LOAD(LOAD),
        .LOAD_VAL(LOAD_VAL),
        .UP_DOWN(UP_DOWN),
        .a(a),
        .b(b),
        .sub(sub),
        .Q(Q),
        .counter_out(counter_out),
        .cout(cout),
        .overflow(overflow)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CARRY_IN = 0;
            LOAD = 0;
            LOAD_VAL = 0;
            UP_DOWN = 0;
            a = 0;
            b = 0;
            sub = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Simple addition (4 + 2)");
            reset_dut();
            a = 4'd4;
            b = 4'd2;
            sub = 0;
            CARRY_IN = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd6, 3'd0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Addition with carry out (12 + 5)");
            reset_dut();
            a = 4'd12;
            b = 4'd5;
            sub = 0;
            CARRY_IN = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(4'd1, 3'd0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Signed overflow (7 + 1)");
            reset_dut();
            a = 4'b0111;
            b = 4'b0001;
            sub = 0;
            CARRY_IN = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(4'b1000, 3'd0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Simple subtraction (10 - 3)");
            reset_dut();
            a = 4'd10;
            b = 4'd3;
            sub = 1;
            CARRY_IN = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(4'd7, 3'd0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Load counter value");
            reset_dut();
            LOAD = 1;
            LOAD_VAL = 3'd5;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd0, 3'd5, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Counter increment");
            reset_dut();

            LOAD = 1;
            LOAD_VAL = 3'd2;
            @(posedge CLK);
            #1;

            LOAD = 0;
            UP_DOWN = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd0, 3'd3, 0, 0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Counter decrement and wrap (0 -> 7)");
            reset_dut();
            LOAD = 1;
            LOAD_VAL = 3'd0;
            @(posedge CLK);
            #1;
            LOAD = 0;
            UP_DOWN = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd0, 3'd7, 0, 0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Simultaneous ALU (sub) and Counter load");
            reset_dut();
            a = 4'd5;
            b = 4'd5;
            sub = 1;
            LOAD = 1;
            LOAD_VAL = 3'd4;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd0, 3'd4, 1, 0);
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
        testcase008();
        
        
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
        input [3:0] expected_Q;
        input [2:0] expected_counter_out;
        input expected_cout;
        input expected_overflow;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out) &&
                expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, counter_out=%h, cout=%b, overflow=%b",
                         Q, counter_out, cout, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, counter_out=%h, cout=%b, overflow=%b",
                         expected_Q, expected_counter_out, expected_cout, expected_overflow);
                $display("  Got:      Q=%h, counter_out=%h, cout=%b, overflow=%b",
                         Q, counter_out, cout, overflow);
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
        $dumpvars(0,CARRY_IN, CLK, LOAD, LOAD_VAL, UP_DOWN, a, b, sub, Q, counter_out, cout, overflow);
    end

endmodule
