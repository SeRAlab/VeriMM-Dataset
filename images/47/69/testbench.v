`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    wire [7:0] out_and;
    wire [7:0] out_final;
    wire [7:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out_and(out_and),
        .out_final(out_final),
        .out_xor(out_xor)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            in1 = 8'h0;
            in2 = 8'h0;
            in3 = 8'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            reset_dut();
            in1 = 8'h00;
            in2 = 8'h00;
            in3 = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic XOR and AND", test_num);
            reset_dut();
            in1 = 8'hFF;
            in2 = 8'hAA;
            in3 = 8'hF0;



            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA0, 8'hF5, 8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: AND result zeroed by in3", test_num);
            reset_dut();
            in1 = 8'hFF;
            in2 = 8'hFF;
            in3 = 8'h00;



            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise Toggle Check", test_num);
            reset_dut();
            in1 = 8'h55;
            in2 = 8'hAA;
            in3 = 8'hFF;



            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'hFF, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Summation with Overflow", test_num);
            reset_dut();
            in1 = 8'h81;
            in2 = 8'h01;
            in3 = 8'h81;



            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01, 8'h81, 8'h80);


            in1 = 8'hFF;
            in2 = 8'h01;
            in3 = 8'hFF;



            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01, 8'hFF, 8'hFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            reset_dut();
            in1 = 8'hFF;
            in2 = 8'hFF;
            in3 = 8'hFF;



            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 8'hFF, 8'h00);
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
        input [7:0] expected_out_and;
        input [7:0] expected_out_final;
        input [7:0] expected_out_xor;
        begin
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_final === (expected_out_final ^ out_final ^ expected_out_final) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_and=%h, out_final=%h, out_xor=%h",
                         out_and, out_final, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%h, out_final=%h, out_xor=%h",
                         expected_out_and, expected_out_final, expected_out_xor);
                $display("  Got:      out_and=%h, out_final=%h, out_xor=%h",
                         out_and, out_final, out_xor);
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
        $dumpvars(0,clk, in1, in2, in3, out_and, out_final, out_xor);
    end

endmodule
