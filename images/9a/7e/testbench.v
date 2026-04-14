`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg btn;
    reg clk;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .btn(btn),
        .clk(clk),
        .X(X)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin
            btn = 0;
            @(posedge clk);
            #1;

            for (i = 0; i < 4; i = i + 1) begin
                btn = 1;
                @(posedge clk);
                #1;
                btn = 0;
                @(posedge clk);
                #1;
            end
            $display("DUT reset sequence complete (Position 0).");
        end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        btn = 0;
        #5;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        btn = 1;
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        btn = 1;
        @(posedge clk);
        #5;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        repeat(2) @(posedge clk) btn = 1;
        #5;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        repeat(3) @(posedge clk) btn = 1;
        #5;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        repeat(4) @(posedge clk) btn = 1;
        #5;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        repeat(2) @(posedge clk) btn = 1;
        #2;
        btn = 0;
        #3;
        #1;

        check_outputs(0);
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
        input expected_X;
        begin
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%b",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b",
                         expected_X);
                $display("  Got:      X=%b",
                         X);
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
        $dumpvars(0,btn, clk, X);
    end

endmodule
