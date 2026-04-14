`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    wire [31:0] B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 32'h00000000;
        $display("Test %0d: A = %h (Zero)", test_num, A);
        #1;

        check_outputs(32'h00000004);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 32'h0000000A;
        $display("Test %0d: A = %h (Small value)", test_num, A);
        #1;

        check_outputs(32'h0000000E);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 32'h7FFFFFF0;
        $display("Test %0d: A = %h (Large positive)", test_num, A);
        #1;

        check_outputs(32'h7FFFFFF4);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 32'hFFFFFFFC;
        $display("Test %0d: A = %h (Boundary wrap to 0)", test_num, A);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 32'hFFFFFFFD;
        $display("Test %0d: A = %h (Boundary wrap to 1)", test_num, A);
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 32'hFFFFFFFF;
        $display("Test %0d: A = %h (Max 32-bit)", test_num, A);
        #1;

        check_outputs(32'h00000003);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 32'h55555555;
        $display("Test %0d: A = %h (Pattern 5s)", test_num, A);
        #1;

        check_outputs(32'h55555559);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 32'h0000FFFF;
        $display("Test %0d: A = %h (Internal carry)", test_num, A);
        #1;

        check_outputs(32'h00010003);
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
        input [31:0] expected_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B === (expected_B ^ B ^ expected_B)) begin
                $display("PASS");
                $display("  Outputs: B=%h",
                         B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%h",
                         expected_B);
                $display("  Got:      B=%h",
                         B);
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
