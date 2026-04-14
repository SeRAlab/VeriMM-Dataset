`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    reg [31:0] Tao_Q;
    reg write;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RST(RST),
        .Tao_Q(Tao_Q),
        .write(write),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            Tao_Q = 0;
            write = 0;
            repeat (2) @(posedge CLK);
            #1;
            RST = 0;
            repeat (1) @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic countdown (Threshold=10)", test_num);
            reset_dut();
            @(posedge CLK);
            Tao_Q = 32'd10;
            write = 1;
            @(posedge CLK);
            write = 0;

            repeat (15) @(posedge CLK);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verify ready is 0 during countdown (Threshold=20)", test_num);
            reset_dut();
            @(posedge CLK);
            Tao_Q = 32'd20;
            write = 1;
            @(posedge CLK);
            write = 0;

            repeat (10) @(posedge CLK);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Larger threshold (Threshold=100)", test_num);
            reset_dut();
            @(posedge CLK);
            Tao_Q = 32'd100;
            write = 1;
            @(posedge CLK);
            write = 0;

            repeat (105) @(posedge CLK);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();
            @(posedge CLK);
            Tao_Q = 32'd50;
            write = 1;
            @(posedge CLK);
            write = 0;
            repeat (25) @(posedge CLK);
            RST = 1;
            repeat (2) @(posedge CLK);
            RST = 0;
            repeat (10) @(posedge CLK);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Repetitive operation (2 consecutive writes)", test_num);
            reset_dut();


            Tao_Q = 32'd5;
            write = 1;
            @(posedge CLK);
            write = 0;
            repeat (10) @(posedge CLK);


            Tao_Q = 32'd8;
            write = 1;
            @(posedge CLK);
            write = 0;
            repeat (12) @(posedge CLK);

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
        input expected_ready;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: ready=%b",
                         ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b",
                         expected_ready);
                $display("  Got:      ready=%b",
                         ready);
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
        $dumpvars(0,CLK, RST, Tao_Q, write, ready);
    end

endmodule
