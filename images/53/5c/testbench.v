`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data;
    reg rotate_left;
    reg rotate_right;
    reg [1:0] shift;
    reg shift_left;
    reg shift_right;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .rotate_left(rotate_left),
        .rotate_right(rotate_right),
        .shift(shift),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data = 4'b0000;
            shift = 2'b00;
            shift_left = 1'b0;
            shift_right = 1'b0;
            rotate_left = 1'b0;
            rotate_right = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b1011;
            shift = 2'b01;
            shift_left = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Logical Shift Left by 1 (Data: 1011)", test_num);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b1011;
            shift = 2'b10;
            shift_left = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Logical Shift Left by 2 (Data: 1011)", test_num);
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b1011;
            shift = 2'b01;
            shift_right = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Logical Shift Right by 1 (Data: 1011)", test_num);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b1011;
            shift = 2'b11;
            shift_right = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Logical Shift Right by 3 (Data: 1011)", test_num);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b1011;
            shift = 2'b01;
            rotate_left = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Rotate Left by 1 (Data: 1011)", test_num);
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b1011;
            shift = 2'b11;
            rotate_left = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Rotate Left by 3 (Data: 1011)", test_num);
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b1011;
            shift = 2'b01;
            rotate_right = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Rotate Right by 1 (Data: 1011)", test_num);
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b1011;
            shift = 2'b10;
            rotate_right = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Rotate Right by 2 (Data: 1011)", test_num);
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b1111;
            shift = 2'b00;
            rotate_left = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Zero Shift (Data: 1111)", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b1000;
            shift = 2'b01;
            rotate_right = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Rotate Right 1 (Data: 1000)", test_num);
            #1;

            check_outputs(4'b0100);
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
        input [3:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, data, rotate_left, rotate_right, shift, shift_left, shift_right, result);
    end

endmodule
