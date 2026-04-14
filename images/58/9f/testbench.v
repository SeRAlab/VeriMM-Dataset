`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dirty;
    wire clean;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dirty(dirty),
        .clean(clean)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            dirty = 0;

            repeat(130) @(posedge clk);
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase %0d: Short high pulse (glitch) filtration", test_num);
            dirty = 1;
            repeat(60) @(posedge clk);
            dirty = 0;
            repeat(140) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase %0d: Stable high signal propagation", test_num);
            dirty = 1;
            repeat(130) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            dirty = 1;
            repeat(130) @(posedge clk);

            $display("Testcase %0d: Stable low signal propagation after high", test_num);
            dirty = 0;
            repeat(130) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase %0d: Noisy signal that never stays stable for 127 cycles", test_num);

            repeat(10) begin
                dirty = 1;
                repeat(50) @(posedge clk);
                dirty = 0;
                repeat(50) @(posedge clk);
            end
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase %0d: Boundary check (126 cycles high)", test_num);
            dirty = 1;
            repeat(126) @(posedge clk);
            dirty = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase %0d: Recovery after noise burst", test_num);

            dirty = 1; repeat(20) @(posedge clk);
            dirty = 0; repeat(10) @(posedge clk);
            dirty = 1; repeat(30) @(posedge clk);
            dirty = 0; repeat(5)  @(posedge clk);


            dirty = 1;
            repeat(130) @(posedge clk);
            #1;

            check_outputs(1'b1);
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
        input expected_clean;
        begin
            if (expected_clean === (expected_clean ^ clean ^ expected_clean)) begin
                $display("PASS");
                $display("  Outputs: clean=%b",
                         clean);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clean=%b",
                         expected_clean);
                $display("  Got:      clean=%b",
                         clean);
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
        $dumpvars(0,clk, dirty, clean);
    end

endmodule
