`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg Enable;
    reg [31:0] In;
    reg Reset;
    reg Set;
    wire [31:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .Enable(Enable),
        .In(In),
        .Reset(Reset),
        .Set(Set),
        .Out(Out)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            Reset = 1;
            Set = 0;
            Enable = 0;
            In = 0;
            #10;
            Reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            Reset = 1;
            #2;
            #1;

            check_outputs(RESET_VAL);
            Reset = 0;
            #8;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            Set = 1;
            #2;
            #1;

            check_outputs(SET_VAL);
            Set = 0;
            #8;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            In = 32'hABCDE123;
            Enable = 1;
            @(posedge Clock);
            #2;
            #1;

            check_outputs(32'hABCDE123);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            In = 32'h5555AAAA;
            Enable = 1;
            @(posedge Clock);
            #2;

            Enable = 0;
            In = 32'hFFFFFFFF;
            @(posedge Clock);
            #2;
            #1;

            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            Reset = 1;
            Set = 1;
            #5;
            #1;

            check_outputs(RESET_VAL);
            Reset = 0;
            Set = 0;
            #5;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            Enable = 1;
            In = 32'h12345678;
            @(posedge Clock);
            #2;

            Reset = 1;
            #2;
            #1;

            check_outputs(RESET_VAL);
            Reset = 0;
            #8;
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
        input [31:0] expected_Out;
        begin
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
        $dumpvars(0,Clock, Enable, In, Reset, Set, Out);
    end

endmodule
