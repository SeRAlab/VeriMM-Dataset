`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg rst;
    wire [7:0] instrcode;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .rst(rst),
        .instrcode(instrcode)
    );

    // Clock generation (10ns period)
    initial begin
        rst = 0;
        forever #5 rst = ~rst;
    end

        task reset_dut;

        begin


            repeat (2) @(posedge rst);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Accessing Address 0x00", test_num);
            reset_dut();
            addr = 8'h00;
            repeat (1) @(posedge rst);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Accessing Address 0x01", test_num);
            reset_dut();
            addr = 8'h01;
            repeat (1) @(posedge rst);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Accessing Mid-Range Address 0x7F", test_num);
            reset_dut();
            addr = 8'h7F;
            repeat (1) @(posedge rst);
            #1;
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Accessing Boundary Address 0xFF", test_num);
            reset_dut();
            addr = 8'hFF;
            repeat (1) @(posedge rst);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Rapid Address Change Post-Reset", test_num);
            reset_dut();
            addr = 8'h0A;
            repeat (1) @(posedge rst);
            #1;

            addr = 8'h0B;
            repeat (1) @(posedge rst);
            #1;
            #1;

            check_outputs(8'h0B);
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
        input [7:0] expected_instrcode;
        begin
            if (expected_instrcode === (expected_instrcode ^ instrcode ^ expected_instrcode)) begin
                $display("PASS");
                $display("  Outputs: instrcode=%h",
                         instrcode);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instrcode=%h",
                         expected_instrcode);
                $display("  Got:      instrcode=%h",
                         instrcode);
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
        $dumpvars(0,addr, rst, instrcode);
    end

endmodule
