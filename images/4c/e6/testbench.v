`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg fpu_op_i;
    reg [27:0] fracta_i;
    reg [27:0] fractb_i;
    reg rst;
    reg signa_i;
    reg signb_i;
    wire [27:0] fract_o;
    wire sign_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .fpu_op_i(fpu_op_i),
        .fracta_i(fracta_i),
        .fractb_i(fractb_i),
        .rst(rst),
        .signa_i(signa_i),
        .signb_i(signb_i),
        .fract_o(fract_o),
        .sign_o(sign_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            fpu_op_i = 0;
            fracta_i = 0;
            fractb_i = 0;
            signa_i = 0;
            signb_i = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive Addition (10 + 20)", test_num);
            reset_dut();
            fpu_op_i = 0;
            signa_i = 0;
            signb_i = 0;
            fracta_i = 28'h000000A;
            fractb_i = 28'h0000014;

            repeat(2) @(posedge clk); #1;
            #1;

            check_outputs(28'h000001E, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Addition (-5 + -5)", test_num);
            reset_dut();
            fpu_op_i = 0;
            signa_i = 1;
            signb_i = 1;
            fracta_i = 28'h0000005;
            fractb_i = 28'h0000005;

            repeat(2) @(posedge clk); #1;
            #1;

            check_outputs(28'h000000A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Effective Subtraction (100 - 40)", test_num);
            reset_dut();
            fpu_op_i = 0;
            signa_i = 0;
            signb_i = 1;
            fracta_i = 28'h0000064;
            fractb_i = 28'h0000028;

            repeat(2) @(posedge clk); #1;
            #1;

            check_outputs(28'h000003C, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Effective Subtraction (40 - 100)", test_num);
            reset_dut();
            fpu_op_i = 0;
            signa_i = 0;
            signb_i = 1;
            fracta_i = 28'h0000028;
            fractb_i = 28'h0000064;

            repeat(2) @(posedge clk); #1;
            #1;

            check_outputs(28'h000003C, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Opcode Subtraction (50 - 10)", test_num);
            reset_dut();
            fpu_op_i = 1;
            signa_i = 0;
            signb_i = 0;
            fracta_i = 28'h0000032;
            fractb_i = 28'h000000A;

            repeat(2) @(posedge clk); #1;
            #1;

            check_outputs(28'h0000028, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Opcode Subtraction (-10 - -5)", test_num);
            reset_dut();
            fpu_op_i = 1;
            signa_i = 1;
            signb_i = 1;
            fracta_i = 28'h000000A;
            fractb_i = 28'h0000005;

            repeat(2) @(posedge clk); #1;
            #1;

            check_outputs(28'h0000005, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Result (255 - 255)", test_num);
            reset_dut();
            fpu_op_i = 1;
            signa_i = 0;
            signb_i = 0;
            fracta_i = 28'h00000FF;
            fractb_i = 28'h00000FF;

            repeat(2) @(posedge clk); #1;
            #1;

            check_outputs(28'h0000000, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Value Addition", test_num);
            reset_dut();
            fpu_op_i = 0;
            signa_i = 0;
            signb_i = 0;
            fracta_i = 28'h7FFFFFF;
            fractb_i = 28'h0000001;

            repeat(2) @(posedge clk); #1;

            #1;


            check_outputs(28'h8000000, 1'b0);
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
        input [27:0] expected_fract_o;
        input expected_sign_o;
        begin
            if (expected_fract_o === (expected_fract_o ^ fract_o ^ expected_fract_o) &&
                expected_sign_o === (expected_sign_o ^ sign_o ^ expected_sign_o)) begin
                $display("PASS");
                $display("  Outputs: fract_o=%h, sign_o=%b",
                         fract_o, sign_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fract_o=%h, sign_o=%b",
                         expected_fract_o, expected_sign_o);
                $display("  Got:      fract_o=%h, sign_o=%b",
                         fract_o, sign_o);
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
        $dumpvars(0,clk, fpu_op_i, fracta_i, fractb_i, rst, signa_i, signb_i, fract_o, sign_o);
    end

endmodule
