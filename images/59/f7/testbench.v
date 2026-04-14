`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] DATA_A;
    reg [3:0] DATA_B;
    reg ENABLE;
    wire [7:0] RESULT;
    wire VALID;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA_A(DATA_A),
        .DATA_B(DATA_B),
        .ENABLE(ENABLE),
        .RESULT(RESULT),
        .VALID(VALID)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            ENABLE = 0;
            DATA_A = 0;
            DATA_B = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: 0 x 0 with ENABLE=1", test_num);
            DATA_A = 4'd0;
            DATA_B = 4'd0;
            ENABLE = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: 15 x 15 (Max values) with ENABLE=1", test_num);
            DATA_A = 4'd15;
            DATA_B = 4'd15;
            ENABLE = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd225, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: 5 x 3 with ENABLE=1", test_num);
            DATA_A = 4'd5;
            DATA_B = 4'd3;
            ENABLE = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd15, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: 12 x 1 with ENABLE=1", test_num);
            DATA_A = 4'd12;
            DATA_B = 4'd1;
            ENABLE = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd12, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: 10 x 10 with ENABLE=0 (Disable Check)", test_num);
            DATA_A = 4'd10;
            DATA_B = 4'd10;
            ENABLE = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: 7 x 11 with ENABLE=1", test_num);
            DATA_A = 4'd7;
            DATA_B = 4'd11;
            ENABLE = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd77, 1'b1);
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
        input [7:0] expected_RESULT;
        input expected_VALID;
        begin
            if (expected_RESULT === (expected_RESULT ^ RESULT ^ expected_RESULT) &&
                expected_VALID === (expected_VALID ^ VALID ^ expected_VALID)) begin
                $display("PASS");
                $display("  Outputs: RESULT=%h, VALID=%b",
                         RESULT, VALID);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RESULT=%h, VALID=%b",
                         expected_RESULT, expected_VALID);
                $display("  Got:      RESULT=%h, VALID=%b",
                         RESULT, VALID);
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
        $dumpvars(0,CLK, DATA_A, DATA_B, ENABLE, RESULT, VALID);
    end

endmodule
