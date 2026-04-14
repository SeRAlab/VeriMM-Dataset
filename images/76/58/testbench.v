`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] dsp_sel;
    reg [3:0] opA;
    reg [3:0] opB;
    reg [4:0] sum;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dsp_sel(dsp_sel),
        .opA(opA),
        .opB(opB),
        .sum(sum),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select lower 4 bits of sum (dsp_sel = 00)", test_num);
        opA = 4'hA;
        opB = 4'hB;
        sum = 5'b0_1101;
        dsp_sel = 2'b00;
        #1;

        check_outputs(4'hD);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select cout from sum[4] (dsp_sel = 01)", test_num);
        opA = 4'hA;
        opB = 4'hB;
        sum = 5'b1_0000;
        dsp_sel = 2'b01;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select opB (dsp_sel = 10)", test_num);
        opA = 4'h3;
        opB = 4'h7;
        sum = 5'h1F;
        dsp_sel = 2'b10;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select opA (dsp_sel = 11)", test_num);
        opA = 4'hE;
        opB = 4'h1;
        sum = 5'h00;
        dsp_sel = 2'b11;
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select cout when cout is 0 (dsp_sel = 01)", test_num);
        opA = 4'hF;
        opB = 4'hF;
        sum = 5'b0_1111;
        dsp_sel = 2'b01;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verify sum bits with different pattern (dsp_sel = 00)", test_num);
        opA = 4'h0;
        opB = 4'h0;
        sum = 5'b1_1010;
        dsp_sel = 2'b00;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Switch selection rapidly opB to opA", test_num);
        opA = 4'h5;
        opB = 4'hC;
        sum = 5'h00;
        dsp_sel = 2'b10; #1;
        dsp_sel = 2'b11;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs maxed, select opB", test_num);
        opA = 4'hF;
        opB = 4'hF;
        sum = 5'h1F;
        dsp_sel = 2'b10;
        #1;

        check_outputs(4'hF);
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
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
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

endmodule
