`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clear;
    reg Clock;
    reg Enable;
    reg Load;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clear(Clear),
        .Clock(Clock),
        .Enable(Enable),
        .Load(Load),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

    begin
        Clear = 1;
        Enable = 0;
        Load = 0;
        @(posedge Clock);
        #1;
        Clear = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        Load = 1;
        @(posedge Clock);
        #1;
        Load = 0;

        #1;


        check_outputs(4'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        Load = 1;
        @(posedge Clock);
        #1;
        Load = 0;
        Enable = 1;
        @(posedge Clock);
        #1;

        #1;


        check_outputs(4'd9);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        Load = 1;
        @(posedge Clock);
        #1;
        Load = 0;
        Enable = 1;
        repeat(10) @(posedge Clock);
        #1;

        #1;


        check_outputs(4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        Load = 1;
        @(posedge Clock);
        #1;
        Load = 0;
        Enable = 1;

        repeat(11) @(posedge Clock);
        #1;
        #1;

        check_outputs(4'd10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        Load = 1;
        @(posedge Clock);
        #1;
        Load = 0;
        Enable = 0;
        repeat(3) @(posedge Clock);
        #1;

        #1;


        check_outputs(4'd10);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        Load = 1;
        Clear = 1;
        @(posedge Clock);
        #1;

        #1;


        check_outputs(4'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        Enable = 1;
        @(posedge Clock);
        #1;

        #1;


        check_outputs(4'd10);
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
        $dumpvars(0,Clear, Clock, Enable, Load, Q);
    end

endmodule
