`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CARRY_IN;
    reg CLK;
    reg LOAD;
    reg [2:0] LOAD_VAL;
    reg UP_DOWN;
    wire [2:0] Q;

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
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            @(negedge CLK);
            LOAD = 1;
            LOAD_VAL = 3'b000;
            UP_DOWN = 0;
            CARRY_IN = 0;
            @(posedge CLK);
            #1;
            LOAD = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Direct Load 3'b101", test_num);
            reset_dut();
            @(negedge CLK);
            LOAD = 1;
            LOAD_VAL = 3'b101;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Count Up from 0 by 1", test_num);
            reset_dut();
            @(negedge CLK);
            UP_DOWN = 1;
            CARRY_IN = 1;
            LOAD = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Count Down from 5 by 1", test_num);
            reset_dut();

            @(negedge CLK);
            LOAD = 1;
            LOAD_VAL = 3'b101;
            @(posedge CLK);
            #1;

            @(negedge CLK);
            LOAD = 0;
            UP_DOWN = 0;
            CARRY_IN = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Overflow Check (7 + 1)", test_num);
            reset_dut();

            @(negedge CLK);
            LOAD = 1;
            LOAD_VAL = 3'b111;
            @(posedge CLK);
            #1;

            @(negedge CLK);
            LOAD = 0;
            UP_DOWN = 1;
            CARRY_IN = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Underflow Check (0 - 1)", test_num);
            reset_dut();

            @(negedge CLK);
            LOAD = 0;
            UP_DOWN = 0;
            CARRY_IN = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: No Count when CARRY_IN=0", test_num);
            reset_dut();

            @(negedge CLK);
            LOAD = 1;
            LOAD_VAL = 3'b011;
            @(posedge CLK);
            #1;

            @(negedge CLK);
            LOAD = 0;
            UP_DOWN = 1;
            CARRY_IN = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Multiple Increments (0 + 1 + 1 + 1)", test_num);
            reset_dut();
            @(negedge CLK);
            UP_DOWN = 1;
            CARRY_IN = 1;
            LOAD = 0;

            @(posedge CLK); #1;
            @(posedge CLK); #1;
            @(posedge CLK); #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Load Override Priority", test_num);
            reset_dut();
            @(negedge CLK);
            LOAD = 1;
            LOAD_VAL = 3'b110;
            UP_DOWN = 1;
            CARRY_IN = 1;
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
        $dumpvars(0,CARRY_IN, CLK, LOAD, LOAD_VAL, UP_DOWN, Q);
    end

endmodule
