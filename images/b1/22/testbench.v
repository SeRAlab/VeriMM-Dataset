`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg mode;
    reg reset;
    wire max_reached;
    wire min_reached;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mode(mode),
        .reset(reset),
        .max_reached(max_reached),
        .min_reached(min_reached),
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
            mode = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset state check...");
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Up mode - count to maximum (7)...");
            reset_dut();
            mode = 1;

            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 3'b111);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Up mode - wrap around (7 to 0)...");
            reset_dut();
            mode = 1;

            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 3'b000);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Down mode - min indicator at 0...");
            reset_dut();
            mode = 0;
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 3'b000);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Down mode - wrap around (0 to 7)...");
            reset_dut();
            mode = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 3'b111);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Down mode - full cycle back to 0...");
            reset_dut();
            mode = 0;

            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 3'b000);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Mode switching mid-count...");
            reset_dut();
            mode = 1;
            repeat(4) @(posedge clk);
            mode = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 3'b010);
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
        input expected_max_reached;
        input expected_min_reached;
        input [2:0] expected_q;
        begin
            if (expected_max_reached === (expected_max_reached ^ max_reached ^ expected_max_reached) &&
                expected_min_reached === (expected_min_reached ^ min_reached ^ expected_min_reached) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: max_reached=%b, min_reached=%b, q=%h",
                         max_reached, min_reached, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max_reached=%b, min_reached=%b, q=%h",
                         expected_max_reached, expected_min_reached, expected_q);
                $display("  Got:      max_reached=%b, min_reached=%b, q=%h",
                         max_reached, min_reached, q);
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
        $dumpvars(0,clk, mode, reset, max_reached, min_reached, q);
    end

endmodule
