`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg up_down;
    wire carry_out;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .up_down(up_down),
        .carry_out(carry_out),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            up_down = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial reset state", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count up 3 cycles (0 to 3)", test_num);
            reset_dut();
            up_down = 1;
            repeat(3) @(negedge clk);
            #1;

            check_outputs(1'b0, 3'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count up 7 cycles (0 to 7)", test_num);
            reset_dut();
            up_down = 1;
            repeat(7) @(negedge clk);
            #1;

            check_outputs(1'b0, 3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count up 8 cycles (Wrap 7 to 0)", test_num);
            reset_dut();
            up_down = 1;
            repeat(8) @(negedge clk);
            #1;

            check_outputs(1'b1, 3'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count down 1 cycle (Wrap 0 to 7)", test_num);
            reset_dut();
            up_down = 0;
            @(negedge clk);
            #1;

            check_outputs(1'b1, 3'd7);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count down 3 cycles (0->7->6->5)", test_num);
            reset_dut();
            up_down = 0;
            repeat(3) @(negedge clk);
            #1;

            check_outputs(1'b0, 3'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Up 4 then Down 2 (0->4->2)", test_num);
            reset_dut();
            up_down = 1;
            repeat(4) @(negedge clk);
            up_down = 0;
            repeat(2) @(negedge clk);
            #1;

            check_outputs(1'b0, 3'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count down 8 cycles (0 back to 0)", test_num);
            reset_dut();
            up_down = 0;
            repeat(8) @(negedge clk);
            #1;

            check_outputs(1'b0, 3'd0);
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
        input expected_carry_out;
        input [2:0] expected_q;
        begin
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, q=%h",
                         carry_out, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, q=%h",
                         expected_carry_out, expected_q);
                $display("  Got:      carry_out=%b, q=%h",
                         carry_out, q);
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
        $dumpvars(0,clk, reset, up_down, carry_out, q);
    end

endmodule
