`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] in;
    reg load;
    reg rst;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .in(in),
        .load(load),
        .rst(rst),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            enable = 0;
            in = 4'b0000;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check");
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Load Value Check");
            reset_dut();
            @(posedge clk);
            load = 1;
            in = 4'b1011;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Single Shift Left Wrap-around");
            reset_dut();

            @(posedge clk);
            load = 1;
            in = 4'b1000;
            @(posedge clk);
            #1;
            load = 0;

            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Multiple Shifts Left Wrap-around");
            reset_dut();

            @(posedge clk);
            load = 1;
            in = 4'b0110;
            @(posedge clk);
            #1;
            load = 0;
            enable = 1;

            @(posedge clk);

            @(posedge clk);
            #1;
            enable = 0;
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Full Rotation (4 shifts)");
            reset_dut();

            @(posedge clk);
            load = 1;
            in = 4'b1010;
            @(posedge clk);
            #1;
            load = 0;
            enable = 1;

            repeat(4) @(posedge clk);
            #1;
            enable = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Idle state (No load/No enable)");
            reset_dut();

            @(posedge clk);
            load = 1;
            in = 4'b0101;
            @(posedge clk);
            #1;
            load = 0;
            enable = 0;

            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Load priority over Enable");
            reset_dut();

            @(posedge clk);
            load = 1;
            in = 4'b0011;
            @(posedge clk);
            #1;

            load = 1;
            enable = 1;
            in = 4'b1111;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1111);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Reset priority over Load and Enable");
            reset_dut();

            @(posedge clk);
            load = 1;
            in = 4'b1111;
            @(posedge clk);
            #1;

            rst = 1;
            load = 1;
            enable = 1;
            in = 4'b1010;
            @(posedge clk);
            #1;

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
        input [3:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, enable, in, load, rst, out);
    end

endmodule
