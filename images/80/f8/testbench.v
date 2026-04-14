`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in0;
    reg [3:0] in1;
    reg sub;
    wire OVF;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .sub(sub),
        .OVF(OVF),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in0 = 4'd0;
            in1 = 4'd0;
            sub = 1'b0;
            @(posedge clk);
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 3 + 2 = 5 (No Overflow)", test_num);
            in0 = 4'd3;
            in1 = 4'd2;
            sub = 1'b0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 7 + 1 = -8 (Overflow)", test_num);
            in0 = 4'sb0111;
            in1 = 4'sb0001;
            sub = 1'b0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 4'b1000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 5 - 2 = 3 (No Overflow)", test_num);
            in0 = 4'd5;
            in1 = 4'd2;
            sub = 1'b1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'd3);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: -5 - 4 = 7 (Overflow)", test_num);
            in0 = 4'sb1011;
            in1 = 4'sb0100;
            sub = 1'b1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 4'b0111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: -2 + -3 = -5 (No Overflow)", test_num);
            in0 = 4'sb1110;
            in1 = 4'sb1101;
            sub = 1'b0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'b1011);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: -6 + -5 = 5 (Overflow)", test_num);
            in0 = 4'sb1010;
            in1 = 4'sb1011;
            sub = 1'b0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 4'b0101);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 6 - (-3) = -7 (Overflow)", test_num);
            in0 = 4'sb0110;
            in1 = 4'sb1101;
            sub = 1'b1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 4'b1001);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 0 - 0 = 0 (No Overflow)", test_num);
            in0 = 4'd0;
            in1 = 4'd0;
            sub = 1'b1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'd0);
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
        input expected_OVF;
        input [3:0] expected_out;
        begin
            if (expected_OVF === (expected_OVF ^ OVF ^ expected_OVF) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: OVF=%b, out=%h",
                         OVF, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OVF=%b, out=%h",
                         expected_OVF, expected_out);
                $display("  Got:      OVF=%b, out=%h",
                         OVF, out);
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
        $dumpvars(0,clk, in0, in1, sub, OVF, out);
    end

endmodule
