`timescale 1ns/1ps

module alu64_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    reg [2:0] op;
    wire [63:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu64 dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Addition", test_num);
        a = 64'd100;
        b = 64'd250;
        op = 3'b000;
        #1;

        check_outputs(64'd350);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Subtraction", test_num);
        a = 64'd500;
        b = 64'd150;
        op = 3'b001;
        #1;

        check_outputs(64'd350);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise AND", test_num);
        a = 64'hAAAA_AAAA_AAAA_AAAA;
        b = 64'hFFFF_FFFF_0000_0000;
        op = 3'b010;
        #1;

        check_outputs(64'hAAAA_AAAA_0000_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise OR", test_num);
        a = 64'h1234_0000_0000_5678;
        b = 64'h0000_FFFF_FFFF_0000;
        op = 3'b011;
        #1;

        check_outputs(64'h1234_FFFF_FFFF_5678);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise XOR", test_num);
        a = 64'hF0F0_F0F0_F0F0_F0F0;
        b = 64'hFFFF_FFFF_FFFF_FFFF;
        op = 3'b100;
        #1;

        check_outputs(64'h0F0F_0F0F_0F0F_0F0F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition with 64-bit Overflow", test_num);
        a = 64'hFFFF_FFFF_FFFF_FFFF;
        b = 64'd1;
        op = 3'b000;
        #1;

        check_outputs(64'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction Underflow (Negative Result)", test_num);
        a = 64'd0;
        b = 64'd1;
        op = 3'b001;
        #1;

        check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large Addition", test_num);
        a = 64'h1000_0000_0000_0000;
        b = 64'h2000_0000_0000_0000;
        op = 3'b000;
        #1;

        check_outputs(64'h3000_0000_0000_0000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: AND with zero", test_num);
        a = 64'hFFFF_FFFF_FFFF_FFFF;
        b = 64'h0;
        op = 3'b010;
        #1;

        check_outputs(64'h0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: XOR with self", test_num);
        a = 64'hDEAD_BEEF_CAFE_BABE;
        b = 64'hDEAD_BEEF_CAFE_BABE;
        op = 3'b100;
        #1;

        check_outputs(64'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu64 Testbench");
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
        input [63:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
