`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire eql;
    wire noteql;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .eql(eql),
        .noteql(noteql)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=0x00, b=0x00 (Equal Zeros)", test_num);
        a = 8'h00;
        b = 8'h00;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=0xFF, b=0xFF (Equal Ones)", test_num);
        a = 8'hFF;
        b = 8'hFF;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=0x55, b=0x55 (Equal Pattern)", test_num);
        a = 8'h55;
        b = 8'h55;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=0x00, b=0x01 (LSB Diff)", test_num);
        a = 8'h00;
        b = 8'h01;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=0x80, b=0x00 (MSB Diff)", test_num);
        a = 8'h80;
        b = 8'h00;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=0xAA, b=0x55 (Complements)", test_num);
        a = 8'hAA;
        b = 8'h55;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a=0x10, b=0x18 (Internal Bit Diff)", test_num);
        a = 8'h10;
        b = 8'h18;
        #1;

        check_outputs(1'b0, 1'b1);
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
        input expected_eql;
        input expected_noteql;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eql === (expected_eql ^ eql ^ expected_eql) &&
                expected_noteql === (expected_noteql ^ noteql ^ expected_noteql)) begin
                $display("PASS");
                $display("  Outputs: eql=%b, noteql=%b",
                         eql, noteql);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eql=%b, noteql=%b",
                         expected_eql, expected_noteql);
                $display("  Got:      eql=%b, noteql=%b",
                         eql, noteql);
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
