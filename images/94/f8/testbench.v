`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_IN;
    reg [1:0] cMode;
    reg enb_1_2000_0;
    reg reset;
    wire [1:0] index;
    wire reset_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_IN(CLK_IN),
        .cMode(cMode),
        .enb_1_2000_0(enb_1_2000_0),
        .reset(reset),
        .index(index),
        .reset_1(reset_1)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_IN = 0;
        forever #5 CLK_IN = ~CLK_IN;
    end

        task reset_dut;

        begin
            reset = 1;
            cMode = 2'b00;
            enb_1_2000_0 = 0;
            repeat(2) @(posedge CLK_IN);
            reset = 0;
            repeat(1) @(posedge CLK_IN);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: System Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Transition to Mode 1 with Enable", test_num);
            reset_dut();
            @(posedge CLK_IN);
            enb_1_2000_0 = 1;
            cMode = 2'b01;
            repeat(2) @(posedge CLK_IN);

            #1;


            check_outputs(2'b01, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Transition to Mode 2 with Enable", test_num);
            reset_dut();
            @(posedge CLK_IN);
            enb_1_2000_0 = 1;
            cMode = 2'b10;
            repeat(2) @(posedge CLK_IN);
            #1;

            check_outputs(2'b10, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Mode change with Enable LOW", test_num);
            reset_dut();

            enb_1_2000_0 = 1;
            cMode = 2'b01;
            @(posedge CLK_IN);

            enb_1_2000_0 = 0;
            cMode = 2'b10;
            repeat(2) @(posedge CLK_IN);

            #1;


            check_outputs(2'b01, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Verify reset_1 logic during mode transition", test_num);
            reset_dut();
            enb_1_2000_0 = 1;
            cMode = 2'b00;
            @(posedge CLK_IN);
            cMode = 2'b11;

            @(posedge CLK_IN);


            #1;



            check_outputs(2'b11, 1'b0);
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
        input [1:0] expected_index;
        input expected_reset_1;
        begin
            if (expected_index === (expected_index ^ index ^ expected_index) &&
                expected_reset_1 === (expected_reset_1 ^ reset_1 ^ expected_reset_1)) begin
                $display("PASS");
                $display("  Outputs: index=%h, reset_1=%b",
                         index, reset_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: index=%h, reset_1=%b",
                         expected_index, expected_reset_1);
                $display("  Got:      index=%h, reset_1=%b",
                         index, reset_1);
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
        $dumpvars(0,CLK_IN, cMode, enb_1_2000_0, reset, index, reset_1);
    end

endmodule
