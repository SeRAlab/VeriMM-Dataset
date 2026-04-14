`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] LOAD;
    reg RST;
    reg UD;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .LOAD(LOAD),
        .RST(RST),
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
            RST = 1;
            UD = 1;
            LOAD = 4'b0;
            #10;
            RST = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Count Up 5 Cycles", test_num);
            reset_dut();
            UD = 1;
            repeat (5) @(posedge CLK);
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Count Down 3 Cycles from 0 (Underflow)", test_num);
            reset_dut();
            UD = 0;
            repeat (3) @(posedge CLK);
            #2;

            #1;


            check_outputs(4'hD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Asynchronous Load value 4'hA", test_num);
            reset_dut();
            LOAD = 4'hA;
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Load 14 and Count Up 3 times (Overflow)", test_num);
            reset_dut();
            LOAD = 4'hE;
            #2;
            LOAD = 4'h0;
            UD = 1;
            repeat (3) @(posedge CLK);
            #2;

            #1;


            check_outputs(4'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Count Up 4 times then Down 2 times", test_num);
            reset_dut();
            UD = 1;
            repeat (4) @(posedge CLK);
            UD = 0;
            repeat (2) @(posedge CLK);
            #2;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Load 0 and Count Down 1 cycle", test_num);
            reset_dut();
            LOAD = 4'h0;
            #2;
            UD = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Reset mid-counting", test_num);
            reset_dut();
            UD = 1;
            repeat (10) @(posedge CLK);
            RST = 1;
            #2;
            #1;

            check_outputs(4'h0);
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
        $dumpvars(0,CLK, LOAD, RST, UD, Q);
    end

endmodule
