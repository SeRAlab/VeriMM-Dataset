`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] pt;
    wire [31:0] l0x;
    wire [31:0] r0x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pt(pt),
        .l0x(l0x),
        .r0x(r0x)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros Input", test_num);
        pt = 64'h0000000000000000;
        #1;

        check_outputs(32'h00000000, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones Input", test_num);
        pt = 64'hffffffffffffffff;
        #1;

        check_outputs(32'hffffffff, 32'hffffffff);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating 0101 Input (0x55...)", test_num);
        pt = 64'h5555555555555555;
        #1;

        check_outputs(32'hffffffff, 32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating 1010 Input (0xAA...)", test_num);
        pt = 64'haaaaaaaaaaaaaaaa;
        #1;

        check_outputs(32'h00000000, 32'hffffffff);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Standard Vector 0123456789ABCDEF", test_num);
        pt = 64'h0123456789abcdef;
        #1;

        check_outputs(32'hcc00ccff, 32'hf0aaf0aa);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise Inverse Vector FEDCBA9876543210", test_num);
        pt = 64'hfedcba9876543210;
        #1;

        check_outputs(32'h33ff3300, 32'h0ff50f55);
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
        input [31:0] expected_l0x;
        input [31:0] expected_r0x;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_l0x === (expected_l0x ^ l0x ^ expected_l0x) &&
                expected_r0x === (expected_r0x ^ r0x ^ expected_r0x)) begin
                $display("PASS");
                $display("  Outputs: l0x=%h, r0x=%h",
                         l0x, r0x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: l0x=%h, r0x=%h",
                         expected_l0x, expected_r0x);
                $display("  Got:      l0x=%h, r0x=%h",
                         l0x, r0x);
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
