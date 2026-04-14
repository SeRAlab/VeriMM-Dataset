`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a1_0;
    reg [1:0] op;
    wire [3:0] be;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a1_0(a1_0),
        .op(op),
        .be(be)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: op=00 (All bits set)", test_num);
        op = 2'b00; a1_0 = 2'b00;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: op=00 (All bits set, checking different a1_0)", test_num);
        op = 2'b00; a1_0 = 2'b11;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: op=01, a1_0[1]=0 (Expect 0011)", test_num);
        op = 2'b01; a1_0 = 2'b01;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: op=01, a1_0[1]=1 (Expect 1100)", test_num);
        op = 2'b01; a1_0 = 2'b10;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: op=10, a1_0=00 (Decoder bit 0)", test_num);
        op = 2'b10; a1_0 = 2'b00;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: op=10, a1_0=01 (Decoder bit 1)", test_num);
        op = 2'b10; a1_0 = 2'b01;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: op=10, a1_0=10 (Decoder bit 2)", test_num);
        op = 2'b10; a1_0 = 2'b10;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: op=10, a1_0=11 (Decoder bit 3)", test_num);
        op = 2'b10; a1_0 = 2'b11;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: op=11 (Expect 0000)", test_num);
        op = 2'b11; a1_0 = 2'b00;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: op=11 (Expect 0000, checking different a1_0)", test_num);
        op = 2'b11; a1_0 = 2'b11;
        #1;

        check_outputs(4'b0000);
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
        input [3:0] expected_be;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_be === (expected_be ^ be ^ expected_be)) begin
                $display("PASS");
                $display("  Outputs: be=%h",
                         be);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: be=%h",
                         expected_be);
                $display("  Got:      be=%h",
                         be);
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
