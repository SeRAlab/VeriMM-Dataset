`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] h_count;
    reg rst;
    reg [9:0] v_count;
    wire h_sync;
    wire v_sync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .h_count(h_count),
        .rst(rst),
        .v_count(v_count),
        .h_sync(h_sync),
        .v_sync(v_sync)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            h_count = 0;
            v_count = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            h_count = 10'd100;
            v_count = 10'd100;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            h_count = 10'd650;
            v_count = 10'd0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            h_count = 10'd656;
            v_count = 10'd0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            h_count = 10'd751;
            v_count = 10'd0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            h_count = 10'd752;
            v_count = 10'd0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            h_count = 10'd0;
            v_count = 10'd485;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            h_count = 10'd0;
            v_count = 10'd490;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            h_count = 10'd700;
            v_count = 10'd491;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            h_count = 10'd0;
            v_count = 10'd492;
            #1;

            check_outputs(1'b1, 1'b1);
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
        input expected_h_sync;
        input expected_v_sync;
        begin
            if (expected_h_sync === (expected_h_sync ^ h_sync ^ expected_h_sync) &&
                expected_v_sync === (expected_v_sync ^ v_sync ^ expected_v_sync)) begin
                $display("PASS");
                $display("  Outputs: h_sync=%b, v_sync=%b",
                         h_sync, v_sync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h_sync=%b, v_sync=%b",
                         expected_h_sync, expected_v_sync);
                $display("  Got:      h_sync=%b, v_sync=%b",
                         h_sync, v_sync);
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
        $dumpvars(0,clk, h_count, rst, v_count, h_sync, v_sync);
    end

endmodule
