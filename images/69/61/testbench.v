`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg EN;
    reg [1:0] SEL;
    wire [3:0] MO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .EN(EN),
        .SEL(SEL),
        .MO(MO)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: EN=0, SEL=00", test_num);
        EN = 1'b0;
        SEL = 2'b00;
        A = 4'hA;
        B = 4'h5;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: EN=1, SEL=00 (Select A)", test_num);
        EN = 1'b1;
        SEL = 2'b00;
        A = 4'hA;
        B = 4'h5;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: EN=1, SEL=01 (Select B)", test_num);
        EN = 1'b1;
        SEL = 2'b01;
        A = 4'hA;
        B = 4'h5;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: EN=1, SEL=10 (Select LOW)", test_num);
        EN = 1'b1;
        SEL = 2'b10;
        A = 4'hF;
        B = 4'hE;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: EN=1, SEL=11 (Select LOW)", test_num);
        EN = 1'b1;
        SEL = 2'b11;
        A = 4'hF;
        B = 4'hE;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: EN=0, SEL=01 (Select B while disabled)", test_num);
        EN = 1'b0;
        SEL = 2'b01;
        A = 4'h3;
        B = 4'hC;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: EN=1, SEL=00, A=4'hF", test_num);
        EN = 1'b1;
        SEL = 2'b00;
        A = 4'hF;
        B = 4'h0;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: EN=1, SEL=01, B=4'hF", test_num);
        EN = 1'b1;
        SEL = 2'b01;
        A = 4'h0;
        B = 4'hF;
        #1;

        check_outputs(4'hF);
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
        input [3:0] expected_MO;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_MO === (expected_MO ^ MO ^ expected_MO)) begin
                $display("PASS");
                $display("  Outputs: MO=%h",
                         MO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MO=%h",
                         expected_MO);
                $display("  Got:      MO=%h",
                         MO);
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
