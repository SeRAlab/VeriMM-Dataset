`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] ra1_EX;
    reg [4:0] ra2_EX;
    reg regwrite_WB;
    reg [4:0] wa_WB;
    wire forwardA;
    wire forwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ra1_EX(ra1_EX),
        .ra2_EX(ra2_EX),
        .regwrite_WB(regwrite_WB),
        .wa_WB(wa_WB),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: No forwarding (Mismatched Addresses)", test_num);
        regwrite_WB = 1'b1;
        wa_WB       = 5'd10;
        ra1_EX      = 5'd5;
        ra2_EX      = 5'd6;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Forward to Operand A", test_num);
        regwrite_WB = 1'b1;
        wa_WB       = 5'd15;
        ra1_EX      = 5'd15;
        ra2_EX      = 5'd2;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Forward to Operand B", test_num);
        regwrite_WB = 1'b1;
        wa_WB       = 5'd20;
        ra1_EX      = 5'd3;
        ra2_EX      = 5'd20;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Forward to Both A and B", test_num);
        regwrite_WB = 1'b1;
        wa_WB       = 5'd25;
        ra1_EX      = 5'd25;
        ra2_EX      = 5'd25;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: No forwarding (RegWrite inactive)", test_num);
        regwrite_WB = 1'b0;
        wa_WB       = 5'd10;
        ra1_EX      = 5'd10;
        ra2_EX      = 5'd10;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: No forwarding (Write to x0)", test_num);
        regwrite_WB = 1'b1;
        wa_WB       = 5'd0;
        ra1_EX      = 5'd0;
        ra2_EX      = 5'd0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Forwarding with Max Register Index (31)", test_num);
        regwrite_WB = 1'b1;
        wa_WB       = 5'd31;
        ra1_EX      = 5'd31;
        ra2_EX      = 5'd0;
        #1;

        check_outputs(1'b1, 1'b0);
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
        input expected_forwardA;
        input expected_forwardB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forwardA === (expected_forwardA ^ forwardA ^ expected_forwardA) &&
                expected_forwardB === (expected_forwardB ^ forwardB ^ expected_forwardB)) begin
                $display("PASS");
                $display("  Outputs: forwardA=%b, forwardB=%b",
                         forwardA, forwardB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forwardA=%b, forwardB=%b",
                         expected_forwardA, expected_forwardB);
                $display("  Got:      forwardA=%b, forwardB=%b",
                         forwardA, forwardB);
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
