`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [2:0] D;
    reg LD;
    reg UD;
    wire [2:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .LD(LD),
        .UD(UD),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            @(posedge CLK);
            LD = 1;
            D = 3'b000;
            UD = 0;
            @(posedge CLK);
            #1;
            LD = 0;
            $display("DUT Reset: Q loaded with 0");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Loading value 5", test_num);
            reset_dut();
            @(posedge CLK);
            LD = 1;
            D = 3'b101;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Incrementing from 0", test_num);
            reset_dut();
            LD = 0;
            UD = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Incrementing from 7 (Wrap-around)", test_num);
            reset_dut();
            LD = 1;
            D = 3'b111;
            @(posedge CLK);
            LD = 0;
            UD = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Decrementing from 4", test_num);
            reset_dut();
            LD = 1;
            D = 3'b100;
            @(posedge CLK);
            LD = 0;
            UD = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Decrementing from 0 (Wrap-around)", test_num);
            reset_dut();
            LD = 0;
            UD = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Incrementing 3 times from 2", test_num);
            reset_dut();
            LD = 1;
            D = 3'b010;
            @(posedge CLK);
            LD = 0;
            UD = 0;
            repeat(3) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Decrementing 4 times from 6", test_num);
            reset_dut();
            LD = 1;
            D = 3'b110;
            @(posedge CLK);
            LD = 0;
            UD = 1;
            repeat(4) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Load priority over counting", test_num);
            reset_dut();
            LD = 1;
            D = 3'b110;
            UD = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b110);
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
        input [2:0] expected_Q;
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
        $dumpvars(0,CLK, D, LD, UD, Q);
    end

endmodule
