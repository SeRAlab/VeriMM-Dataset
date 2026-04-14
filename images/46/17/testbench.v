`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [511:0] A;
    wire [63:0] B;

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
        $display("Test %03d: All Zeros", test_num);
        A = 512'h0;
        #1;

        check_outputs(calculate_expected(A));
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %03d: All Ones", test_num);
        A = {16{32'hFFFFFFFF}};
        #1;

        check_outputs(calculate_expected(A));
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %03d: LSB of every byte set (0x01 per byte)", test_num);
        A = {64{8'h01}};
        #1;

        check_outputs(calculate_expected(A));
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %03d: MSB of every byte set (0x80 per byte)", test_num);
        A = {64{8'h80}};
        #1;

        check_outputs(calculate_expected(A));
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Alternating pattern (0x01000100...)", test_num);
        A = {32{16'h0100}};
        #1;

        check_outputs(calculate_expected(A));
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Walking bit (Bit 0 of Byte 10)", test_num);
        A = 512'h0;
        A[10*8] = 1'b1;
        #1;

        check_outputs(calculate_expected(A));
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Random data pattern", test_num);
        A = 512'hA5A5A5A5_5A5A5A5A_0F0F0F0F_F0F0F0F0_12345678_9ABCDEFF_FEDCBA98_76543210_A5A5A5A5_5A5A5A5A_0F0F0F0F_F0F0F0F0_12345678_9ABCDEFF_FEDCBA98_76543210;
        #1;

        check_outputs(calculate_expected(A));
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
        input [63:0] expected_B;
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
