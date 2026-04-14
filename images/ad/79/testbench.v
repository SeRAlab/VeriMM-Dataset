`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Ctrl;
    reg [31:0] Imm32;
    wire [63:0] BusImm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ctrl(Ctrl),
        .Imm32(Imm32),
        .BusImm(BusImm)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Sign Extension - Positive Number", test_num);
        Ctrl = 1'b0;
        Imm32 = 32'h12345678;

        #1;


        check_outputs(64'h0000000012345678);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Sign Extension - Negative Number", test_num);
        Ctrl = 1'b0;
        Imm32 = 32'h80001234;

        #1;


        check_outputs(64'hFFFFFFFF80001234);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Zero Extension - Positive Number", test_num);
        Ctrl = 1'b1;
        Imm32 = 32'h12345678;

        #1;


        check_outputs(64'h0000000012345678);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Zero Extension - Negative Number", test_num);
        Ctrl = 1'b1;
        Imm32 = 32'h80001234;

        #1;


        check_outputs(64'h0000000080001234);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Sign Extension - All Ones", test_num);
        Ctrl = 1'b0;
        Imm32 = 32'hFFFFFFFF;

        #1;


        check_outputs(64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Zero Extension - All Ones", test_num);
        Ctrl = 1'b1;
        Imm32 = 32'hFFFFFFFF;

        #1;


        check_outputs(64'h00000000FFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Sign Extension - All Zeros", test_num);
        Ctrl = 1'b0;
        Imm32 = 32'h00000000;

        #1;


        check_outputs(64'h0000000000000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Sign Extension - Boundary MSB (0x7FFFFFFF)", test_num);
        Ctrl = 1'b0;
        Imm32 = 32'h7FFFFFFF;

        #1;


        check_outputs(64'h000000007FFFFFFF);
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
        input [63:0] expected_BusImm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BusImm === (expected_BusImm ^ BusImm ^ expected_BusImm)) begin
                $display("PASS");
                $display("  Outputs: BusImm=%h",
                         BusImm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BusImm=%h",
                         expected_BusImm);
                $display("  Got:      BusImm=%h",
                         BusImm);
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
