`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clear;
    reg Clk;
    reg t;
    wire q;
    wire qbar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clear(Clear),
        .Clk(Clk),
        .t(t),
        .q(q),
        .qbar(qbar)
    );

    // Clock generation (10ns period)
    initial begin
        Clear = 0;
        forever #5 Clear = ~Clear;
    end

        task reset_dut;

        begin
            Clear = 0;
            t = 0;
            #15;
            Clear = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggle from 0 to 1 (t=1)", test_num);
            reset_dut();
            t = 1;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Double Toggle", test_num);
            reset_dut();
            t = 1;
            @(posedge Clk);
            @(posedge Clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold state (t=0)", test_num);
            reset_dut();
            t = 0;
            @(posedge Clk);
            @(posedge Clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggle then Hold", test_num);
            reset_dut();
            t = 1;
            @(posedge Clk);
            t = 0;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Clear Trigger", test_num);
            reset_dut();
            t = 1;
            @(posedge Clk);
            #2;
            Clear = 0;
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_q;
        input expected_qbar;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_qbar === (expected_qbar ^ qbar ^ expected_qbar)) begin
                $display("PASS");
                $display("  Outputs: q=%b, qbar=%b",
                         q, qbar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, qbar=%b",
                         expected_q, expected_qbar);
                $display("  Got:      q=%b, qbar=%b",
                         q, qbar);
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
        $dumpvars(0,Clear, Clk, t, q, qbar);
    end

endmodule
