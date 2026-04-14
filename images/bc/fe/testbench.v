`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset_n;
    reg serial_in;
    wire [11:0] shift_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .reset_n(reset_n),
        .serial_in(serial_in),
        .shift_reg(shift_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset_n = 0;
            enable = 0;
            serial_in = 0;
            @(negedge clk);
            reset_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset and Single Bit Shift", test_num);
            reset_dut();

            @(negedge clk);
            enable = 1;
            serial_in = 1;
            @(negedge clk);
            enable = 0;

            #1;


            check_outputs(12'h001);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill Register with 1s", test_num);
            reset_dut();

            @(negedge clk);
            enable = 1;
            serial_in = 1;
            for (i = 0; i < 12; i = i + 1) begin
                @(negedge clk);
            end
            enable = 0;

            #1;


            check_outputs(12'hFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Enable Hold", test_num);
            reset_dut();


            @(negedge clk);
            enable = 1;
            serial_in = 1;
            @(negedge clk);
            serial_in = 0;
            @(negedge clk);
            serial_in = 1;


            @(negedge clk);
            enable = 0;
            serial_in = 0;
            @(negedge clk);
            serial_in = 1;
            @(negedge clk);

            #1;


            check_outputs(12'h005);
        end
        endtask

    task testcase004;

        integer i;
        reg [11:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Pattern 1010...", test_num);
            reset_dut();
            pattern = 12'b101010101010;

            @(negedge clk);
            enable = 1;
            for (i = 11; i >= 0; i = i - 1) begin
                serial_in = pattern[i];
                @(negedge clk);
            end
            enable = 0;

            #1;


            check_outputs(12'hAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Reset Override", test_num);
            reset_dut();


            @(negedge clk);
            enable = 1;
            serial_in = 1;
            @(negedge clk);
            @(negedge clk);


            reset_n = 0;
            serial_in = 1;
            @(negedge clk);
            reset_n = 1;
            enable = 0;

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Through Full Register", test_num);
            reset_dut();

            @(negedge clk);
            enable = 1;
            serial_in = 1;
            @(negedge clk);
            serial_in = 0;


            for (i = 0; i < 10; i = i + 1) begin
                @(negedge clk);
            end

            #1;


            check_outputs(12'h800);
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
        input [11:0] expected_shift_reg;
        begin
            if (expected_shift_reg === (expected_shift_reg ^ shift_reg ^ expected_shift_reg)) begin
                $display("PASS");
                $display("  Outputs: shift_reg=%h",
                         shift_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shift_reg=%h",
                         expected_shift_reg);
                $display("  Got:      shift_reg=%h",
                         shift_reg);
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
        $dumpvars(0,clk, enable, reset_n, serial_in, shift_reg);
    end

endmodule
