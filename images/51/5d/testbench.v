`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] add;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .add(add)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 32'h00000000;
        B = 32'h00000000;
        $display("Test %0d: Zero Addition (0 + 0)", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 32'd12345;
        B = 32'd54321;
        $display("Test %0d: Small Positive Addition", test_num);
        #1;

        check_outputs(32'd66666);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 32'hFFFFFFFF;
        B = 32'h00000000;
        $display("Test %0d: Max Value + Zero", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        $display("Test %0d: Overflow / Wrap-around (Max + 1)", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 32'hAAAAAAAA;
        B = 32'h55555555;
        $display("Test %0d: Alternating Bits Pattern", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 32'h12345678;
        B = 32'h87654321;
        $display("Test %0d: Large Hex Addition", test_num);
        #1;

        check_outputs(32'h99999999);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 32'h7FFFFFFF;
        B = 32'h7FFFFFFF;
        $display("Test %0d: Signed Positive Max Addition", test_num);
        #1;

        check_outputs(32'hFFFFFFFE);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 32'h80000000;
        B = 32'h80000000;
        $display("Test %0d: Power of 2 Overflow", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 32'hF0F0F0F0;
        B = 32'h0F0F0F0F;
        $display("Test %0d: Nibble Pattern Addition", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 32'hDEADBEEF;
        B = 32'h11111111;
        $display("Test %0d: Random Hex Addition", test_num);
        #1;

        check_outputs(32'hEFECCFFF);
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
        input [31:0] expected_add;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_add === (expected_add ^ add ^ expected_add)) begin
                $display("PASS");
                $display("  Outputs: add=%h",
                         add);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add=%h",
                         expected_add);
                $display("  Got:      add=%h",
                         add);
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
