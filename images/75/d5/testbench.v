`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg controlSignal;
    reg [31:0] input0;
    reg [31:0] input1;
    wire [31:0] muxOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .controlSignal(controlSignal),
        .input0(input0),
        .input1(input1),
        .muxOut(muxOut)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select input0 (Standard values)", test_num);
            controlSignal = 1'b0;
            input0 = 32'h12345678;
            input1 = 32'h9ABCDEF0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select input1 (Standard values)", test_num);
            controlSignal = 1'b1;
            input0 = 32'h12345678;
            input1 = 32'h9ABCDEF0;
            #1;

            check_outputs(32'h9ABCDEF0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select input0 (All zeros vs All ones)", test_num);
            controlSignal = 1'b0;
            input0 = 32'h00000000;
            input1 = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select input1 (All zeros vs All ones)", test_num);
            controlSignal = 1'b1;
            input0 = 32'h00000000;
            input1 = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Select input0 (Alternating bits)", test_num);
            controlSignal = 1'b0;
            input0 = 32'hAAAAAAAA;
            input1 = 32'h55555555;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Select input1 (Alternating bits)", test_num);
            controlSignal = 1'b1;
            input0 = 32'hAAAAAAAA;
            input1 = 32'h55555555;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Selection when inputs are identical", test_num);
            controlSignal = 1'b1;
            input0 = 32'hDEADBEEF;
            input1 = 32'hDEADBEEF;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Selecting single bit set in MSB", test_num);
            controlSignal = 1'b1;
            input0 = 32'h00000000;
            input1 = 32'h80000000;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Selecting single bit set in LSB", test_num);
            controlSignal = 1'b0;
            input0 = 32'h00000001;
            input1 = 32'h00000000;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Random data check", test_num);
            controlSignal = 1'b1;
            input0 = 32'hCAFEBABE;
            input1 = 32'hFEEDFACE;
            #1;

            check_outputs(32'hFEEDFACE);
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
        input [31:0] expected_muxOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_muxOut === (expected_muxOut ^ muxOut ^ expected_muxOut)) begin
                $display("PASS");
                $display("  Outputs: muxOut=%h",
                         muxOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: muxOut=%h",
                         expected_muxOut);
                $display("  Got:      muxOut=%h",
                         muxOut);
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
