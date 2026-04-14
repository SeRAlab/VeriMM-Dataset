`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg res;
    reg resetn;
    wire [2:0] wins;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .res(res),
        .resetn(resetn),
        .wins(wins)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            resetn = 0;
            res = 0;
            #15;
            resetn = 1;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset and check next state with res=0", test_num);
            reset_dut();
            res = 0;
            #2;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Check next state from A with res=1", test_num);
            reset_dut();
            res = 1;
            #2;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequence transition A -> B, then check next state C", test_num);
            reset_dut();
            res = 1;
            @(posedge clock);
            #2;

            #1;


            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Advance to B then hold (res=0)", test_num);
            reset_dut();
            res = 1;
            @(posedge clock);
            res = 0;
            #2;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Check wrap-around from State H to A", test_num);
            reset_dut();
            res = 1;
            repeat(7) @(posedge clock);
            #2;

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asynchronous Reset verification", test_num);
            reset_dut();
            res = 1;
            @(posedge clock);
            @(posedge clock);
            resetn = 0;
            #2;
            res = 0;
            #1;

            #1;


            check_outputs(3'b000);
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
        input [2:0] expected_wins;
        begin
            if (expected_wins === (expected_wins ^ wins ^ expected_wins)) begin
                $display("PASS");
                $display("  Outputs: wins=%h",
                         wins);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wins=%h",
                         expected_wins);
                $display("  Got:      wins=%h",
                         wins);
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
        $dumpvars(0,clock, res, resetn, wins);
    end

endmodule
