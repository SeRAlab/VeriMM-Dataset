`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down;
    reg reset;
    reg up;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .down(down),
        .reset(reset),
        .up(up),
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
            up = 0;
            down = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Synchronous Reset", test_num);
            reset_dut();
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Increment once (0->1)", test_num);
            reset_dut();
            up = 1;
            @(posedge clk);
            #1;
            up = 0;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Increment to max (0->7)", test_num);
            reset_dut();
            up = 1;
            repeat(7) @(posedge clk);
            #1;
            up = 0;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Increment overflow (7->0)", test_num);
            reset_dut();
            up = 1;
            repeat(8) @(posedge clk);
            #1;
            up = 0;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Decrement underflow (0->7)", test_num);
            reset_dut();
            down = 1;
            @(posedge clk);
            #1;
            down = 0;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Decrement sequence (0->7->6->5)", test_num);
            reset_dut();
            down = 1;
            repeat(3) @(posedge clk);
            #1;
            down = 0;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Mixed Up/Down (0 +3 -1 = 2)", test_num);
            reset_dut();
            up = 1;
            repeat(3) @(posedge clk);
            up = 0;
            down = 1;
            @(posedge clk);
            #1;
            down = 0;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Synchronous reset while incrementing", test_num);
            reset_dut();
            up = 1;
            repeat(4) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            up = 0;
            #1;

            check_outputs(3'b000);
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
        input [2:0] expected_q;
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
        $dumpvars(0,clk, down, reset, up, q);
    end

endmodule
