`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [4:0] load_value;
    reg reset_n;
    reg up_down;
    wire [4:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .reset_n(reset_n),
        .up_down(up_down),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            load = 0;
            up_down = 0;
            load_value = 0;
            #12;
            reset_n = 1;
            #8;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset check");
            reset_dut();

            #1;


            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Synchronous Load");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 5'h1A;
            @(posedge clk);
            #2;
            load = 0;
            #1;

            check_outputs(5'h1A);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Up Counting 5 times");
            reset_dut();
            @(negedge clk);
            up_down = 1;
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Load then Down Counting");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 5'd10;
            @(posedge clk);
            #2;
            load = 0;
            up_down = 0;
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(5'd6);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overflow wrap-around (31 -> 0)");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 5'd31;
            @(posedge clk);
            #2;
            load = 0;
            up_down = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Underflow wrap-around (0 -> 31)");
            reset_dut();
            @(negedge clk);
            up_down = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Load priority over counting");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 5'h0F;
            up_down = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h0F);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Load 0 then decrement 2 times");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 5'd0;
            @(posedge clk);
            #2;
            load = 0;
            up_down = 0;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(5'd30);
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
        input [4:0] expected_q;
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
        $dumpvars(0,clk, load, load_value, reset_n, up_down, q);
    end

endmodule
