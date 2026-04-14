`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [3:0] load_data;
    reg reset;
    reg up_down;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .load_data(load_data),
        .reset(reset),
        .up_down(up_down),
        .count(count)
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
            up_down = 0;
            load_data = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Reset Verification");
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load capability (Value 0xA)");
            reset_dut();
            load = 1;
            load_data = 4'hA;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Up counting (0 to 3)");
            reset_dut();
            up_down = 1;
            load = 0;
            repeat (3) @(posedge clk);
            #1 #1;
 check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Down counting (0 down to 14)");
            reset_dut();
            up_down = 0;
            load = 0;
            repeat (2) @(posedge clk);
            #1 #1;
 check_outputs(4'hE);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Up wrap-around (15 to 0)");
            reset_dut();
            load = 1;
            load_data = 4'hF;
            @(posedge clk);
            #1 load = 0;
            up_down = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Down wrap-around (0 to 15)");
            reset_dut();
            up_down = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Load signal priority");
            reset_dut();
            load = 1;
            load_data = 4'h7;
            up_down = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h7);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Load 0x5 then count down 3 times");
            reset_dut();
            load = 1;
            load_data = 4'h5;
            @(posedge clk);
            #1 load = 0;
            up_down = 0;
            repeat (3) @(posedge clk);
            #1 #1;
 check_outputs(4'h2);
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
        input [3:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, load, load_data, reset, up_down, count);
    end

endmodule
