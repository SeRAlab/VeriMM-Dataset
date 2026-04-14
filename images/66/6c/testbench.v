`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg inp_0a;
    reg [33:0] inp_0d;
    reg out_0r;
    wire inp_0r;
    wire out_0a;
    wire out_0d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inp_0a(inp_0a),
        .inp_0d(inp_0d),
        .out_0r(out_0r),
        .inp_0r(inp_0r),
        .out_0a(out_0a),
        .out_0d(out_0d)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All inputs zero", test_num);
        inp_0a = 1'b0;
        inp_0d = 34'h0;
        out_0r = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Set inp_0a to 1", test_num);
        inp_0a = 1'b1;
        inp_0d = 34'h0;
        out_0r = 1'b0;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Set inp_0d bit 33 to 1", test_num);
        inp_0a = 1'b0;
        inp_0d = 34'h2_0000_0000;
        out_0r = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Set out_0r to 1", test_num);
        inp_0a = 1'b0;
        inp_0d = 34'h0;
        out_0r = 1'b1;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Set inp_0d bits 0-32 to 1 (bit 33 to 0)", test_num);
        inp_0a = 1'b0;
        inp_0d = 34'h1_FFFF_FFFF;
        out_0r = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: All inputs active", test_num);
        inp_0a = 1'b1;
        inp_0d = 34'h3_FFFF_FFFF;
        out_0r = 1'b1;
        #1;

        check_outputs(1'b1, 1'b1, 1'b1);
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
        input expected_inp_0r;
        input expected_out_0a;
        input expected_out_0d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_inp_0r === (expected_inp_0r ^ inp_0r ^ expected_inp_0r) &&
                expected_out_0a === (expected_out_0a ^ out_0a ^ expected_out_0a) &&
                expected_out_0d === (expected_out_0d ^ out_0d ^ expected_out_0d)) begin
                $display("PASS");
                $display("  Outputs: inp_0r=%b, out_0a=%b, out_0d=%b",
                         inp_0r, out_0a, out_0d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inp_0r=%b, out_0a=%b, out_0d=%b",
                         expected_inp_0r, expected_out_0a, expected_out_0d);
                $display("  Got:      inp_0r=%b, out_0a=%b, out_0d=%b",
                         inp_0r, out_0a, out_0d);
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
