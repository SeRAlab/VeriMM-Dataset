`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] adr;
    reg clk;
    reg [31:0] data;
    reg reset;
    reg sel;
    wire pwm_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adr(adr),
        .clk(clk),
        .data(data),
        .reset(reset),
        .sel(sel),
        .pwm_out(pwm_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            sel = 0;
            adr = 0;
            data = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: 50%% Duty Cycle - High Phase Check", test_num);
            reset_dut();
            write_reg(0, 32'd10);
            write_reg(1, 32'd5);
            write_reg(2, 32'd0);


            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: 50%% Duty Cycle - Low Phase Check", test_num);
            reset_dut();
            write_reg(0, 32'd10);
            write_reg(1, 32'd5);
            write_reg(2, 32'd0);


            repeat(7) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: 0%% Duty Cycle Check", test_num);
            reset_dut();
            write_reg(0, 32'd10);
            write_reg(1, 32'd0);
            write_reg(2, 32'd0);

            repeat(1) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: 100%% Duty Cycle Check", test_num);
            reset_dut();
            write_reg(0, 32'd10);
            write_reg(1, 32'd10);
            write_reg(2, 32'd0);

            repeat(8) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Counter Rollover Check", test_num);
            reset_dut();
            write_reg(0, 32'd4);
            write_reg(1, 32'd1);
            write_reg(2, 32'd0);


            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Large Configuration Values", test_num);
            reset_dut();
            write_reg(0, 32'd1000);
            write_reg(1, 32'd800);
            write_reg(2, 32'd799);

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
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
        input expected_pwm_out;
        begin
            if (expected_pwm_out === (expected_pwm_out ^ pwm_out ^ expected_pwm_out)) begin
                $display("PASS");
                $display("  Outputs: pwm_out=%b",
                         pwm_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pwm_out=%b",
                         expected_pwm_out);
                $display("  Got:      pwm_out=%b",
                         pwm_out);
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
        $dumpvars(0,adr, clk, data, reset, sel, pwm_out);
    end

endmodule
