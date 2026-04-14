`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] inp;
    reg process_CE;
    wire [15:0] process_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .inp(inp),
        .process_CE(process_CE),
        .process_output(process_output)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            process_CE = 0;
            inp = 32'h0;
            @(posedge CLK);
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Addition", test_num);
            reset_dut();
            inp = 32'h0000_0000;
            process_CE = 1;
            repeat(3) @(posedge CLK);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Small Integers (1 + 2)", test_num);
            reset_dut();
            inp = 32'h0001_0002;
            process_CE = 1;
            repeat(3) @(posedge CLK);
            #1;

            check_outputs(16'h0003);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sum resulting in 0x8000", test_num);
            reset_dut();
            inp = 32'h4000_4000;
            process_CE = 1;
            repeat(3) @(posedge CLK);
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sum with Overflow/Carry-out", test_num);
            reset_dut();
            inp = 32'hFFFF_0001;
            process_CE = 1;
            repeat(3) @(posedge CLK);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max value addition", test_num);
            reset_dut();
            inp = 32'hFFFF_FFFF;
            process_CE = 1;
            repeat(3) @(posedge CLK);
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random pattern addition", test_num);
            reset_dut();
            inp = 32'hA5A5_5A5A;
            process_CE = 1;
            repeat(3) @(posedge CLK);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Clock Enable (CE) low check", test_num);
            reset_dut();

            inp = 32'h0001_0001;
            process_CE = 1;
            repeat(3) @(posedge CLK);


            inp = 32'h0005_0005;
            process_CE = 0;
            repeat(3) @(posedge CLK);


            #1;



            check_outputs(16'h0002);
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
        input [15:0] expected_process_output;
        begin
            if (expected_process_output === (expected_process_output ^ process_output ^ expected_process_output)) begin
                $display("PASS");
                $display("  Outputs: process_output=%h",
                         process_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: process_output=%h",
                         expected_process_output);
                $display("  Got:      process_output=%h",
                         process_output);
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
        $dumpvars(0,CLK, inp, process_CE, process_output);
    end

endmodule
