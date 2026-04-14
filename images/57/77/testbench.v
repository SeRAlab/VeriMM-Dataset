`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] in;
    reg [1:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .in(in),
        .sel(sel),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            in = 4'b0000;
            sel = 2'b00;

            repeat (5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable Low (Expected High-Z)", test_num);
            reset_dut();
            enable = 0;
            in = 4'b1111;
            sel = 2'b00;
            #2;
            #1;

            check_outputs(1'bz);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sel 0 (Direct Input Path)", test_num);
            reset_dut();
            enable = 1;
            sel = 2'b00;
            in = 4'b0001;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sel 1 (1-Cycle Pipeline Delay)", test_num);
            reset_dut();
            enable = 1;
            sel = 2'b01;
            in = 4'b0010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sel 2 (2-Cycle Pipeline Delay)", test_num);
            reset_dut();
            enable = 1;
            sel = 2'b10;
            in = 4'b0100;
            repeat (2) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sel 3 (3-Cycle Pipeline Delay)", test_num);
            reset_dut();
            enable = 1;
            sel = 2'b11;
            in = 4'b1000;
            repeat (3) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pipeline Independence (Verify delay logic)", test_num);
            reset_dut();
            enable = 1;
            sel = 2'b11;
            in = 4'b1000;
            @(posedge clk);
            in = 4'b0000;
            repeat (2) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable Override during active pipeline", test_num);
            reset_dut();
            enable = 1;
            sel = 2'b01;
            in = 4'b0010;
            @(posedge clk);
            #1;
            enable = 0;
            #2;
            #1;

            check_outputs(1'bz);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Combinatorial Update Sel 0", test_num);
            reset_dut();
            enable = 1;
            sel = 2'b00;
            in = 4'b0000;
            #2;
            in = 4'b0001;
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
        $dumpvars(0,clk, enable, in, sel, out);
    end

endmodule
