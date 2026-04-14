`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst;
    wire pulseOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .rst(rst),
        .pulseOut(pulseOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            enable = 0;
            @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal operation - 50,000 cycles", test_num);
            reset_dut();
            enable = 1;


            for (i = 0; i < 50000; i = i + 1) begin
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary check - 49,999 cycles", test_num);
            reset_dut();
            enable = 1;
            for (i = 0; i < 49999; i = i + 1) begin
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pulse duration check - 50,001 cycles", test_num);
            reset_dut();
            enable = 1;
            for (i = 0; i < 50001; i = i + 1) begin
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable signal pause check", test_num);
            reset_dut();


            enable = 1;
            for (i = 0; i < 25000; i = i + 1) @(posedge clk);


            enable = 0;
            for (i = 0; i < 1000; i = i + 1) @(posedge clk);


            enable = 1;
            for (i = 0; i < 25000; i = i + 1) @(posedge clk);

            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-way reset check", test_num);
            reset_dut();

            enable = 1;

            for (i = 0; i < 40000; i = i + 1) @(posedge clk);


            rst = 0;
            @(posedge clk);
            rst = 1;


            for (i = 0; i < 10000; i = i + 1) @(posedge clk);

            #2;
            #1;

            check_outputs(1'b0);
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
        input expected_pulseOut;
        begin
            if (expected_pulseOut === (expected_pulseOut ^ pulseOut ^ expected_pulseOut)) begin
                $display("PASS");
                $display("  Outputs: pulseOut=%b",
                         pulseOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pulseOut=%b",
                         expected_pulseOut);
                $display("  Got:      pulseOut=%b",
                         pulseOut);
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
        $dumpvars(0,clk, enable, rst, pulseOut);
    end

endmodule
