`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] PC4;
    wire [31:0] PC8;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PC4(PC4),
        .PC8(PC8)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Incrementing from zero", test_num);
        PC4 = 32'h00000000;
        #1;

        check_outputs(32'h00000004);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Typical instruction address 0x4", test_num);
        PC4 = 32'h00000004;
        #1;

        check_outputs(32'h00000008);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Larger address jump 0x1000", test_num);
        PC4 = 32'h00001000;
        #1;

        check_outputs(32'h00001004);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Address near 32-bit boundary", test_num);
        PC4 = 32'h7FFFFFFC;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Overflow/Wrap-around case (PC = 0xFFFFFFFC)", test_num);
        PC4 = 32'hFFFFFFFC;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum 32-bit value wrap-around", test_num);
        PC4 = 32'hFFFFFFFF;
        #1;

        check_outputs(32'h00000003);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random pattern bit-test", test_num);
        PC4 = 32'hAAAA_5554;
        #1;

        check_outputs(32'hAAAA_5558);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random pattern bit-test 2", test_num);
        PC4 = 32'h1234_5678;
        #1;

        check_outputs(32'h1234_567C);
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
        input [31:0] expected_PC8;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PC8 === (expected_PC8 ^ PC8 ^ expected_PC8)) begin
                $display("PASS");
                $display("  Outputs: PC8=%h",
                         PC8);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PC8=%h",
                         expected_PC8);
                $display("  Got:      PC8=%h",
                         PC8);
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
