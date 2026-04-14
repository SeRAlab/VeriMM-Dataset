`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] CHAR_IN;
    reg CLK;
    reg RESET;
    reg [3:0] ROW_NUM;
    wire [9:0] DATA_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CHAR_IN(CHAR_IN),
        .CLK(CLK),
        .RESET(RESET),
        .ROW_NUM(ROW_NUM),
        .DATA_OUT(DATA_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 0;
            CHAR_IN = 8'h00;
            ROW_NUM = 4'd0;
            @(negedge CLK);
            #2 RESET = 1;
            @(negedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Character 'H', Row 0", test_num);
            reset_dut();
            CHAR_IN = 8'h48;
            ROW_NUM = 4'd0;
            @(negedge CLK);
            #2;
            #1;

            check_outputs(10'h201);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Character 'H', Row 3", test_num);
            reset_dut();
            CHAR_IN = 8'h48;
            ROW_NUM = 4'd3;
            @(negedge CLK);
            #2;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Character 'A' (No Match)", test_num);
            reset_dut();
            CHAR_IN = 8'h41;
            ROW_NUM = 4'd0;
            @(negedge CLK);
            #2;
            #1;

            check_outputs(10'bzzzzzzzzzz);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Character 'H', Row 7", test_num);
            reset_dut();
            CHAR_IN = 8'h48;
            ROW_NUM = 4'd7;
            @(negedge CLK);
            #2;
            #1;

            check_outputs(10'h201);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Character '?' (No Match)", test_num);
            reset_dut();
            CHAR_IN = 8'h3F;
            ROW_NUM = 4'd5;
            @(negedge CLK);
            #2;
            #1;

            check_outputs(10'bzzzzzzzzzz);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %03d: Transition Match 'H' to Mismatch 'B'", test_num);
            reset_dut();

            CHAR_IN = 8'h48;
            ROW_NUM = 4'd0;
            @(negedge CLK);
            #1;

            CHAR_IN = 8'h42;
            @(negedge CLK);
            #2;
            #1;

            check_outputs(10'bzzzzzzzzzz);
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
        input [9:0] expected_DATA_OUT;
        begin
            if (expected_DATA_OUT === (expected_DATA_OUT ^ DATA_OUT ^ expected_DATA_OUT)) begin
                $display("PASS");
                $display("  Outputs: DATA_OUT=%h",
                         DATA_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_OUT=%h",
                         expected_DATA_OUT);
                $display("  Got:      DATA_OUT=%h",
                         DATA_OUT);
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
        $dumpvars(0,CHAR_IN, CLK, RESET, ROW_NUM, DATA_OUT);
    end

endmodule
