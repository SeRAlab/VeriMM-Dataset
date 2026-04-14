`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] d;
    reg left_shift;
    reg reset;
    reg right_shift;
    wire [5:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .left_shift(left_shift),
        .reset(reset),
        .right_shift(right_shift),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            left_shift = 0;
            right_shift = 0;
            d = 6'b0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(6'b000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            d = 6'b101101;
            left_shift = 1;
            right_shift = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b101101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            d = 6'b000001; left_shift = 1; right_shift = 1;
            @(posedge clk);

            left_shift = 1; right_shift = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b000010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            d = 6'h20; left_shift = 1; right_shift = 1;
            @(posedge clk);

            left_shift = 0; right_shift = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            d = 6'b111111; left_shift = 1; right_shift = 1;
            @(posedge clk);
            left_shift = 1; right_shift = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(6'b111000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            d = 6'b111111; left_shift = 1; right_shift = 1;
            @(posedge clk);
            left_shift = 0; right_shift = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(6'b001111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            d = 6'b000001; left_shift = 1; right_shift = 1;
            @(posedge clk);
            left_shift = 1; right_shift = 0;
            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(6'b000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            d = 6'b111111; left_shift = 1; right_shift = 1;
            @(posedge clk);

            reset = 1;
            left_shift = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b000000);
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
        input [5:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, left_shift, reset, right_shift, q);
    end

endmodule
