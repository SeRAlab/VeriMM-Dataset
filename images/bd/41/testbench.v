`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg Rst;
    reg Sm;
    wire M;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .Rst(Rst),
        .Sm(Sm),
        .M(M)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            Rst = 1;
            Sm = 0;
            @(posedge CLK);
            #1 Rst = 0;
            @(posedge CLK);
            $display("Reset complete.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Check initial state after reset", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sm asserted, wait for M=1", test_num);
            reset_dut();
            Sm = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Check if M triggers self-reset on next clock", test_num);
            reset_dut();
            Sm = 1;
            @(posedge CLK);
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sm not asserted, M should remain 0", test_num);
            reset_dut();
            Sm = 0;
            repeat(3) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Assert Rst while Sm is active", test_num);
            reset_dut();
            Sm = 1;
            Rst = 1;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: verify cyclic behavior (pulse every 2 cycles)", test_num);
            reset_dut();
            Sm = 1;
            @(posedge CLK);
            @(posedge CLK);
            @(posedge CLK);
            #1;
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
        input expected_M;
        begin
            if (expected_M === (expected_M ^ M ^ expected_M)) begin
                $display("PASS");
                $display("  Outputs: M=%b",
                         M);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M=%b",
                         expected_M);
                $display("  Got:      M=%b",
                         M);
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
        $dumpvars(0,CLK, Rst, Sm, M);
    end

endmodule
