`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] RdE;
    reg RegDstE;
    reg [4:0] RtE;
    wire [4:0] WriteRegE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RdE(RdE),
        .RegDstE(RegDstE),
        .RtE(RtE),
        .WriteRegE(WriteRegE)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select RtE (RegDstE = 0)", test_num);
        RtE = 5'h0A;
        RdE = 5'h15;
        RegDstE = 1'b0;
        #1;

        check_outputs(5'h0A);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select RdE (RegDstE = 1)", test_num);
        RtE = 5'h0A;
        RdE = 5'h15;
        RegDstE = 1'b1;
        #1;

        check_outputs(5'h15);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros, Select RtE", test_num);
        RtE = 5'h00;
        RdE = 5'h1F;
        RegDstE = 1'b0;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones, Select RdE", test_num);
        RtE = 5'h00;
        RdE = 5'h1F;
        RegDstE = 1'b1;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit Pattern 10101, Select RtE", test_num);
        RtE = 5'b10101;
        RdE = 5'b01010;
        RegDstE = 1'b0;
        #1;

        check_outputs(5'b10101);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit Pattern 01010, Select RdE", test_num);
        RtE = 5'b10101;
        RdE = 5'b01010;
        RegDstE = 1'b1;
        #1;

        check_outputs(5'b01010);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Value 31, Select RtE", test_num);
        RtE = 5'd31;
        RdE = 5'd0;
        RegDstE = 1'b0;
        #1;

        check_outputs(5'd31);
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
        input [4:0] expected_WriteRegE;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_WriteRegE === (expected_WriteRegE ^ WriteRegE ^ expected_WriteRegE)) begin
                $display("PASS");
                $display("  Outputs: WriteRegE=%h",
                         WriteRegE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WriteRegE=%h",
                         expected_WriteRegE);
                $display("  Got:      WriteRegE=%h",
                         WriteRegE);
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
