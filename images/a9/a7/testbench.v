`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [15:0] countB;
    reg [11:0] max;
    wire [7:0] number;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .countB(countB),
        .max(max),
        .number(number)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            countB = 0;
            max = 0;
            @(posedge CLK);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: countB = 0", test_num);
            countB = 16'd0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'b11000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: countB = 9", test_num);
            countB = 16'd9;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'b11000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: countB = 10", test_num);
            countB = 16'd10;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'b11111001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: countB = 55", test_num);
            countB = 16'd55;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'b11111001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: countB = 65535", test_num);
            countB = 16'hFFFF;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'b11111001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Transition from 20 to 5", test_num);

            countB = 16'd20;
            @(posedge CLK);
            #2;

            countB = 16'd5;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'b11000000);
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
        input [7:0] expected_number;
        begin
            if (expected_number === (expected_number ^ number ^ expected_number)) begin
                $display("PASS");
                $display("  Outputs: number=%h",
                         number);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: number=%h",
                         expected_number);
                $display("  Got:      number=%h",
                         number);
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
        $dumpvars(0,CLK, countB, max, number);
    end

endmodule
