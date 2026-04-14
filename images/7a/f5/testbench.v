`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] Op;
    reg [31:0] in0;
    reg [31:0] in1;
    reg [31:0] in2;
    reg [31:0] in3;
    wire [31:0] MuxOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Op(Op),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .MuxOut(MuxOut)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select in0 (Op=00)", test_num);
            Op = 2'b00;
            in0 = 32'hDEADBEEF;
            in1 = 32'h00000000;
            in2 = 32'hFFFFFFFF;
            in3 = 32'h12345678;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select in1 (Op=01)", test_num);
            Op = 2'b01;
            in0 = 32'hFFFFFFFF;
            in1 = 32'h00000000;
            in2 = 32'hAAAA_AAAA;
            in3 = 32'h5555_5555;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select in2 (Op=10)", test_num);
            Op = 2'b10;
            in0 = 32'h00000000;
            in1 = 32'h11111111;
            in2 = 32'hFFFFFFFF;
            in3 = 32'h22222222;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select in3 (Op=11)", test_num);
            Op = 2'b11;
            in0 = 32'hCAFE_BABE;
            in1 = 32'hBEEF_FEED;
            in2 = 32'hABCD_1234;
            in3 = 32'h5A5A_A5A5;
            #1;

            check_outputs(32'h5A5A_A5A5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input independence check (Op stays 00)", test_num);
            Op = 2'b00;
            in0 = 32'h11223344;
            in1 = 32'h00000000;
            in2 = 32'h00000000;
            in3 = 32'h00000000;
            #1;

            in1 = 32'hFFFFFFFF;
            in2 = 32'hAAAA5555;
            in3 = 32'h12345678;
            #1;

            check_outputs(32'h11223344);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Selected input dynamic update (Op=10)", test_num);
            Op = 2'b10;
            in2 = 32'hBCBC_BCBC;
            #1;

            in2 = 32'h4321_8765;
            #1;

            check_outputs(32'h4321_8765);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential selector transition", test_num);
            in0 = 32'h00000001;
            in1 = 32'h00000002;
            in2 = 32'h00000004;
            in3 = 32'h00000008;

            Op = 2'b00; #1;
            Op = 2'b01; #1;
            Op = 2'b10; #1;
            Op = 2'b11;
            #1;

            check_outputs(32'h00000008);
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
        input [31:0] expected_MuxOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_MuxOut === (expected_MuxOut ^ MuxOut ^ expected_MuxOut)) begin
                $display("PASS");
                $display("  Outputs: MuxOut=%h",
                         MuxOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MuxOut=%h",
                         expected_MuxOut);
                $display("  Got:      MuxOut=%h",
                         MuxOut);
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
