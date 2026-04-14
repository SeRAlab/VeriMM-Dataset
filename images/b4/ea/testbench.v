`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] address0;
    reg [12:0] address1;
    reg ce0;
    reg ce1;
    reg clk;
    reg [7:0] d0;
    reg [7:0] d1;
    reg reset;
    reg we0;
    reg we1;
    wire [7:0] q0;
    wire [7:0] q1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address0(address0),
        .address1(address1),
        .ce0(ce0),
        .ce1(ce1),
        .clk(clk),
        .d0(d0),
        .d1(d1),
        .reset(reset),
        .we0(we0),
        .we1(we1),
        .q0(q0),
        .q1(q1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            address0 = 0; address1 = 0;
            ce0 = 0; ce1 = 0;
            we0 = 0; we1 = 0;
            d0 = 0; d1 = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            @(posedge clk);
            address0 = 13'h10; d0 = 8'hA5; ce0 = 1; we0 = 1;
            @(posedge clk);

            we0 = 0;
            @(posedge clk);
            #1;

            check_outputs(8'hA5, 8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            @(posedge clk);
            address1 = 13'h20; d1 = 8'h5A; ce1 = 1; we1 = 1;
            @(posedge clk);

            we1 = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clk);
            address0 = 13'h100; d0 = 8'h11; ce0 = 1; we0 = 1;
            address1 = 13'h200; d1 = 8'h22; ce1 = 1; we1 = 1;
            @(posedge clk);
            we0 = 0; we1 = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            @(posedge clk);
            address0 = 13'h50; d0 = 8'hFF; ce0 = 0; we0 = 1;
            @(posedge clk);

            address0 = 13'h50; ce0 = 1; we0 = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            @(posedge clk);
            address1 = 13'h60; d1 = 8'hEE; ce1 = 1; we1 = 0;
            @(posedge clk);

            address1 = 13'h60; ce1 = 1; we1 = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            @(posedge clk);
            address0 = 13'h1FFF; d0 = 8'h77; ce0 = 1; we0 = 1;
            @(posedge clk);
            address0 = 13'h1FFF; we0 = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h77, 8'h00);
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
        input [7:0] expected_q0;
        input [7:0] expected_q1;
        begin
            if (expected_q0 === (expected_q0 ^ q0 ^ expected_q0) &&
                expected_q1 === (expected_q1 ^ q1 ^ expected_q1)) begin
                $display("PASS");
                $display("  Outputs: q0=%h, q1=%h",
                         q0, q1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q0=%h, q1=%h",
                         expected_q0, expected_q1);
                $display("  Got:      q0=%h, q1=%h",
                         q0, q1);
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
        $dumpvars(0,address0, address1, ce0, ce1, clk, d0, d1, reset, we0, we1, q0, q1);
    end

endmodule
