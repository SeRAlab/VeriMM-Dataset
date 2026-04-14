`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg clk;
    reg load;
    reg reset;
    reg [1:0] shift;
    reg shift_dir;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .clk(clk),
        .load(load),
        .reset(reset),
        .shift(shift),
        .shift_dir(shift_dir),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            A = 4'b0000;
            shift = 2'b00;
            shift_dir = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            A = 4'b1011;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            A = 4'b1010; load = 1; @(posedge clk); #1;

            load = 0; shift = 2'b00; shift_dir = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            A = 4'b1000; load = 1; @(posedge clk); #1;

            load = 0; shift = 2'b01; shift_dir = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            A = 4'b1100; load = 1; @(posedge clk); #1;

            load = 0; shift = 2'b10; shift_dir = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            A = 4'b0001; load = 1; @(posedge clk); #1;

            load = 0; shift = 2'b01; shift_dir = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            A = 4'b0011; load = 1; @(posedge clk); #1;

            load = 0; shift = 2'b10; shift_dir = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase008;

        begin
            reset_dut();

            A = 4'b0111; load = 1; @(posedge clk); #1;

            load = 0; shift = 2'b11; shift_dir = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase009;

        begin
            reset_dut();

            A = 4'b1110; load = 1; @(posedge clk); #1;

            load = 0; shift = 2'b11; shift_dir = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            A = 4'b1111; load = 1; reset = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0000);
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,A, clk, load, reset, shift, shift_dir, Q);
    end

endmodule
