`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    reg [1:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 1'b1; B = 1'b0; C = 1'b0; D = 1'b0;
        sel = 2'b00;
        $display("Testcase %0d: Testing sel=00 (A) with A=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 1'b0; B = 1'b1; C = 1'b1; D = 1'b1;
        sel = 2'b00;
        $display("Testcase %0d: Testing sel=00 (A) with A=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 1'b0; B = 1'b1; C = 1'b0; D = 1'b0;
        sel = 2'b01;
        $display("Testcase %0d: Testing sel=01 (B) with B=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 1'b1; B = 1'b0; C = 1'b1; D = 1'b1;
        sel = 2'b01;
        $display("Testcase %0d: Testing sel=01 (B) with B=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 1'b0; B = 1'b0; C = 1'b1; D = 1'b0;
        sel = 2'b10;
        $display("Testcase %0d: Testing sel=10 (C) with C=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 1'b1; B = 1'b1; C = 1'b0; D = 1'b1;
        sel = 2'b10;
        $display("Testcase %0d: Testing sel=10 (C) with C=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 1'b0; B = 1'b0; C = 1'b0; D = 1'b1;
        sel = 2'b11;
        $display("Testcase %0d: Testing sel=11 (D) with D=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 1'b1; B = 1'b1; C = 1'b1; D = 1'b0;
        sel = 2'b11;
        $display("Testcase %0d: Testing sel=11 (D) with D=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 1'b1; B = 1'b1; C = 1'b1; D = 1'b1;
        sel = 2'bxx;
        $display("Testcase %0d: Testing invalid sel (XX) defaults to 0", test_num);
        #1;

        check_outputs(1'b0);
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
