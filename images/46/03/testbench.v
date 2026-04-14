`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] A;
    reg [10:0] B;
    reg S;
    wire [10:0] MO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .S(S),
        .MO(MO)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select A (S=0)", test_num);
        A = 11'h123;
        B = 11'h456;
        S = 1'b0;
        #1;

        check_outputs(11'h123);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select B (S=1)", test_num);
        A = 11'h123;
        B = 11'h456;
        S = 1'b1;
        #1;

        check_outputs(11'h456);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: All Zeros, Select A", test_num);
        A = 11'h000;
        B = 11'h7FF;
        S = 1'b0;
        #1;

        check_outputs(11'h000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: All Ones, Select B", test_num);
        A = 11'h000;
        B = 11'h7FF;
        S = 1'b1;
        #1;

        check_outputs(11'h7FF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Alternating Bits, Select A", test_num);
        A = 11'h555;
        B = 11'h2AA;
        S = 1'b0;
        #1;

        check_outputs(11'h555);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Alternating Bits, Select B", test_num);
        A = 11'h555;
        B = 11'h2AA;
        S = 1'b1;
        #1;

        check_outputs(11'h2AA);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Boundary Value, Select A", test_num);
        A = 11'h7FE;
        B = 11'h001;
        S = 1'b0;
        #1;

        check_outputs(11'h7FE);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Boundary Value, Select B", test_num);
        A = 11'h7FE;
        B = 11'h001;
        S = 1'b1;
        #1;

        check_outputs(11'h001);
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
        input [10:0] expected_MO;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_MO === (expected_MO ^ MO ^ expected_MO)) begin
                $display("PASS");
                $display("  Outputs: MO=%h",
                         MO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MO=%h",
                         expected_MO);
                $display("  Got:      MO=%h",
                         MO);
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
