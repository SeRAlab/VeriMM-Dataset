`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg linein;
    reg reset;
    wire lineout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .linein(linein),
        .reset(reset),
        .lineout(lineout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            linein = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial state (linein LOW)", test_num);
            reset_dut();
            linein = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Positive edge transition (0 -> 1)", test_num);
            reset_dut();
            linein = 0;
            @(posedge clk);
            #1 linein = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Negative edge transition (1 -> 0)", test_num);
            reset_dut();

            linein = 1;
            @(posedge clk);
            #1;

            linein = 0;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verify lineout returns to LOW after one cycle", test_num);
            reset_dut();
            linein = 1;
            @(posedge clk);
            #1 linein = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Stable HIGH state", test_num);
            reset_dut();
            linein = 1;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Detect second negative edge in a sequence", test_num);
            reset_dut();

            linein = 1; @(posedge clk);
            linein = 0; @(posedge clk);

            linein = 1; @(posedge clk);
            #1;
            linein = 0;
            #2;
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
        input expected_lineout;
        begin
            if (expected_lineout === (expected_lineout ^ lineout ^ expected_lineout)) begin
                $display("PASS");
                $display("  Outputs: lineout=%b",
                         lineout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lineout=%b",
                         expected_lineout);
                $display("  Got:      lineout=%b",
                         lineout);
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
        $dumpvars(0,clk, linein, reset, lineout);
    end

endmodule
