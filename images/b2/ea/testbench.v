`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in0;
    reg in1;
    reg in2;
    reg reset;
    reg [2:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .reset(reset),
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
            reset = 1;
            sel = 3'b000;
            in0 = 0;
            in1 = 0;
            in2 = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset behavior", test_num);
            reset = 1;
            sel = 3'b000; in0 = 1; in1 = 1; in2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Select in0 (High)", test_num);
            sel = 3'd0;
            in0 = 1; in1 = 0; in2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Select in1 (High)", test_num);
            sel = 3'd1;
            in0 = 0; in1 = 1; in2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Select in2 (High)", test_num);
            sel = 3'd2;
            in0 = 0; in1 = 0; in2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Select in0 (Low)", test_num);
            sel = 3'd0;
            in0 = 0; in1 = 1; in2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Select in1 (Low)", test_num);
            sel = 3'd1;
            in0 = 1; in1 = 0; in2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Select in2 (Low)", test_num);
            sel = 3'd2;
            in0 = 1; in1 = 1; in2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Invalid Selection (sel=3)", test_num);
            sel = 3'd3;
            in0 = 1; in1 = 1; in2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Invalid Selection (sel=7)", test_num);
            sel = 3'd7;
            in0 = 1; in1 = 1; in2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Timing Check", test_num);
            sel = 3'd0; in0 = 0;
            @(posedge clk);
            #1;

            in0 = 1;
            #2;
            if (out !== 1'b0) begin
                $display("FAIL: Output changed before clock edge");
                fail_count = fail_count + 1;
            end else begin

                @(posedge clk);
                #1;
                #1;

                check_outputs(1'b1);
            end
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
        testcase010();
        
        
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
        $dumpvars(0,clk, in0, in1, in2, reset, sel, out);
    end

endmodule
