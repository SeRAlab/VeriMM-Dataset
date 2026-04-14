`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    reg [1:0] s;
    wire [3:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .s(s),
        .o(o)
    );
    task testcase001;

        begin
            test_num = 1;
            s = 2'b00; b = 1'b1; a = 1'b0; c = 1'b0; d = 1'b0;
            $display("Test %0d: s=0, b=1 (expect 3 copies of b)", test_num);
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            s = 2'b00; b = 1'b0; a = 1'b1; c = 1'b1; d = 1'b1;
            $display("Test %0d: s=0, b=0 (expect 3 copies of b)", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            s = 2'b01; c = 1'b1; a = 1'b0; b = 1'b0; d = 1'b0;
            $display("Test %0d: s=1, c=1 (expect 2 copies of c)", test_num);
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            s = 2'b01; c = 1'b0; a = 1'b1; b = 1'b1; d = 1'b1;
            $display("Test %0d: s=1, c=0 (expect 2 copies of c)", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            s = 2'b10; d = 1'b1; a = 1'b0; b = 1'b0; c = 1'b0;
            $display("Test %0d: s=2, d=1 (expect direct value d)", test_num);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            s = 2'b10; d = 1'b0; a = 1'b1; b = 1'b1; c = 1'b1;
            $display("Test %0d: s=2, d=0 (expect direct value d)", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            s = 2'b11; a = 1'b1; b = 1'b0; c = 1'b0; d = 1'b0;
            $display("Test %0d: s=3, a=1 (expect 4 copies of a)", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            s = 2'b11; a = 1'b0; b = 1'b1; c = 1'b1; d = 1'b1;
            $display("Test %0d: s=3, a=0 (expect 4 copies of a)", test_num);
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
        input [3:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
