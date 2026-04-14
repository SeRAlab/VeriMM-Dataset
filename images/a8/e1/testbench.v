`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg sel;
    wire [7:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .sel(sel),
        .C(C)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Addition (sel=0) - 10 + 20", test_num);
        A = 8'd10;
        B = 8'd20;
        sel = 1'b0;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Addition (sel=0) - 255 + 1 (Overflow)", test_num);
        A = 8'hFF;
        B = 8'h01;
        sel = 1'b0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Addition (sel=0) - 127 + 0", test_num);
        A = 8'd127;
        B = 8'd0;
        sel = 1'b0;
        #1;

        check_outputs(8'd127);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Addition (sel=0) - 128 + 127", test_num);
        A = 8'd128;
        B = 8'd127;
        sel = 1'b0;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Subtraction (sel=1) - 50 - 20", test_num);
        A = 8'd50;
        B = 8'd20;
        sel = 1'b1;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Subtraction (sel=1) - 100 - 100", test_num);
        A = 8'd100;
        B = 8'd100;
        sel = 1'b1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Subtraction (sel=1) - 0 - 1 (Underflow)", test_num);
        A = 8'h00;
        B = 8'h01;
        sel = 1'b1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Subtraction (sel=1) - 255 - 128", test_num);
        A = 8'hFF;
        B = 8'd128;
        sel = 1'b1;
        #1;

        check_outputs(8'd127);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Subtraction (sel=1) - 128 - 0", test_num);
        A = 8'd128;
        B = 8'd0;
        sel = 1'b1;
        #1;

        check_outputs(8'd128);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Toggle Mode - 64 +/- 32", test_num);
        A = 8'd64;
        B = 8'd32;

        sel = 1'b0;
        #1;
        if (C !== 8'd96) $display("Subtest Add Failed");

        sel = 1'b1;
        #1;

        check_outputs(8'd32);
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
        input [7:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
