`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 32'h0;
        b = 32'h0;
        $display("Test %0d: zero multiplication (0 * 0)", test_num);
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 32'hFFFFFFFF;
        b = 32'h0;
        $display("Test %0d: multiplication by zero (max * 0)", test_num);
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 32'h1;
        b = 32'hABCDEF01;
        $display("Test %0d: identity multiplication (1 * A)", test_num);
        #1;

        check_outputs(32'hABCDEF01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 32'd1234;
        b = 32'd5678;
        $display("Test %0d: simple multiplication (1234 * 5678)", test_num);
        #1;

        check_outputs(32'd7006652);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 32'h00000001;
        b = 32'h00008000;
        $display("Test %0d: power of 2 (1 * 2^15)", test_num);
        #1;

        check_outputs(32'h00008000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 32'h00010000;
        b = 32'h00010000;
        $display("Test %0d: overflow check (2^16 * 2^16 = 2^32)", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 32'h00001234;
        b = 32'h00005678;
        $display("Test %0d: large numbers (0x1234 * 0x5678)", test_num);
        #1;

        check_outputs(32'h06260160);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 32'hFFFFFFFF;
        b = 32'hFFFFFFFF;
        $display("Test %0d: max values ( (2^32-1)^2 mod 2^32 )", test_num);

        #1;


        check_outputs(32'h00000001);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 32'h80000000;
        b = 32'h00000002;
        $display("Test %0d: high bit overflow (2^31 * 2)", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 32'hDEADBEEF;
        b = 32'hCAFEBABE;
        $display("Test %0d: complex pattern truncation", test_num);

        #1;


        check_outputs(32'h93361812);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
