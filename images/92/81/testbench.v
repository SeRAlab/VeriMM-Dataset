`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg mode;
    reg [2:0] operand1;
    reg [2:0] operand2;
    wire overflow;
    wire [2:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .mode(mode),
        .operand1(operand1),
        .operand2(operand2),
        .overflow(overflow),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            mode = 0;
            operand1 = 0;
            operand2 = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            mode = 0; operand1 = 3'd2; operand2 = 3'd3;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b0, 3'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            mode = 0; operand1 = 3'd7; operand2 = 3'd0;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b0, 3'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            mode = 0; operand1 = 3'd4; operand2 = 3'd4;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b1, 3'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            mode = 0; operand1 = 3'd7; operand2 = 3'd7;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b1, 3'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            mode = 1; operand1 = 3'd1; operand2 = 3'd1;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b0, 3'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            mode = 1; operand1 = 3'd2; operand2 = 3'd2;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b1, 3'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            mode = 1; operand1 = 3'd3; operand2 = 3'd1;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b1, 3'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            mode = 1; operand1 = 3'd4; operand2 = 3'd4;
            @(posedge clock); #1;

            #1;


            check_outputs(1'b0, 3'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            mode = 1; operand1 = 3'd7; operand2 = 3'd7;
            @(posedge clock); #1;

            #1;


            check_outputs(1'b1, 3'd6);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();

            mode = 0; operand1 = 3'd2; operand2 = 3'd2;
            @(posedge clock); #1;
            if (overflow === 0 && result === 3'd4) begin
                mode = 1;
                @(posedge clock); #1;
                #1;

                check_outputs(1'b1, 3'd4);
            end else begin
                $display("FAIL: Mode 0 phase of testcase 010");
                fail_count = fail_count + 1;
            end
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_overflow;
        input [2:0] expected_result;
        begin
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h",
                         overflow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h",
                         expected_overflow, expected_result);
                $display("  Got:      overflow=%b, result=%h",
                         overflow, result);
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
        $dumpvars(0,clock, mode, operand1, operand2, overflow, result);
    end

endmodule
