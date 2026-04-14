`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] a;
    reg [6:0] b;
    reg [6:0] c;
    reg clk;
    reg [6:0] d;
    reg [5:0] sa;
    reg [5:0] sb;
    reg [5:0] sc;
    reg [5:0] sd;
    wire [6:0] max;
    wire [5:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .d(d),
        .sa(sa),
        .sb(sb),
        .sc(sc),
        .sd(sd),
        .max(max),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0; b = 0; c = 0; d = 0;
            sa = 0; sb = 0; sc = 0; sd = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 7'd100; b = 7'd50; c = 7'd20; d = 7'd80;
            sa = 6'd1;  sb = 6'd2; sc = 6'd3; sd = 6'd4;
            @(posedge clk);
            #2;
            $display("Testcase %0d: 'a' is maximum", test_num);
            #1;

            check_outputs(7'd100, 6'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 7'd10; b = 7'd120; c = 7'd5; d = 7'd60;
            sa = 6'd10; sb = 6'd11; sc = 6'd12; sd = 6'd13;
            @(posedge clk);
            #2;
            $display("Testcase %0d: 'b' is maximum", test_num);
            #1;

            check_outputs(7'd120, 6'd11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 7'd5; b = 7'd15; c = 7'd99; d = 7'd44;
            sa = 6'd20; sb = 6'd21; sc = 6'd22; sd = 6'd23;
            @(posedge clk);
            #2;
            $display("Testcase %0d: 'c' is maximum", test_num);
            #1;

            check_outputs(7'd99, 6'd22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 7'd30; b = 7'd40; c = 7'd50; d = 7'd127;
            sa = 6'd30; sb = 6'd31; sc = 6'd32; sd = 6'd33;
            @(posedge clk);
            #2;
            $display("Testcase %0d: 'd' is maximum (at max range)", test_num);
            #1;

            check_outputs(7'd127, 6'd33);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 7'd64; b = 7'd64; c = 7'd64; d = 7'd64;
            sa = 6'd1;  sb = 6'd2;  sc = 6'd3;  sd = 6'd4;
            @(posedge clk);
            #2;
            $display("Testcase %0d: All values equal", test_num);

            #1;


            check_outputs(7'd64, 6'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 7'd10; b = 7'd85; c = 7'd10; d = 7'd85;
            sa = 6'd5;  sb = 6'd15; sc = 6'd25; sd = 6'd35;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Tie between b and d", test_num);
            #1;

            check_outputs(7'd85, 6'd15);
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
        input [6:0] expected_max;
        input [5:0] expected_state;
        begin
            if (expected_max === (expected_max ^ max ^ expected_max) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: max=%h, state=%h",
                         max, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max=%h, state=%h",
                         expected_max, expected_state);
                $display("  Got:      max=%h, state=%h",
                         max, state);
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
        $dumpvars(0,a, b, c, clk, d, sa, sb, sc, sd, max, state);
    end

endmodule
