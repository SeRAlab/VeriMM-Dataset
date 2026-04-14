`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg en;
    reg load;
    reg up_down;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .load(load),
        .up_down(up_down),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 1;
            en = 0;
            up_down = 0;
            data_in = 4'h0;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Loading specific value (4'hA)");
            reset_dut();
            load = 1;
            data_in = 4'hA;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Counting UP 5 times");
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Loading 4'h7 and counting DOWN 3 times");
            reset_dut();
            load = 1;
            data_in = 4'h7;
            @(posedge clk);
            #1;
            load = 0;
            en = 1;
            up_down = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Verify counter holds value when EN=0");
            reset_dut();
            load = 1;
            data_in = 4'h3;
            @(posedge clk);
            #1;
            load = 0;
            en = 0;
            up_down = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Up counting rollover (4'hF -> 4'h0)");
            reset_dut();
            load = 1;
            data_in = 4'hF;
            @(posedge clk);
            #1;
            load = 0;
            en = 1;
            up_down = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Down counting rollunder (4'h0 -> 4'hF)");
            reset_dut();
            en = 1;
            up_down = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Verify LOAD priority over counting");
            reset_dut();
            load = 1;
            en = 1;
            up_down = 1;
            data_in = 4'hC;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hC);
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
        $dumpvars(0,clk, data_in, en, load, up_down, out);
    end

endmodule
