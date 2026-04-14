`timescale 1ns/1ps

module shift_right_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] binary_num;
    reg clk;
    reg reset;
    wire [7:0] shifted_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_right_module dut (
        .binary_num(binary_num),
        .clk(clk),
        .reset(reset),
        .shifted_num(shifted_num)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            binary_num = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 1: Shift 0xFF (All ones)");
            reset_dut();
            binary_num = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h3F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 2: Shift 0x03 (Lower 2 bits only)");
            reset_dut();
            binary_num = 8'h03;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 3: Shift 0xC0 (Upper bits)");
            reset_dut();
            binary_num = 8'hC0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h30);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 4: Shift 0xAA (Alternating bits)");
            reset_dut();
            binary_num = 8'hAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h2A);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 5: Shift 0x04");
            reset_dut();
            binary_num = 8'h04;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 6: Verify reset state regardless of input");
            reset_dut();
            binary_num = 8'hFF;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_right_module Testbench");
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
        input [7:0] expected_shifted_num;
        begin
            if (expected_shifted_num === (expected_shifted_num ^ shifted_num ^ expected_shifted_num)) begin
                $display("PASS");
                $display("  Outputs: shifted_num=%h",
                         shifted_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted_num=%h",
                         expected_shifted_num);
                $display("  Got:      shifted_num=%h",
                         shifted_num);
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
        $dumpvars(0,binary_num, clk, reset, shifted_num);
    end

endmodule
