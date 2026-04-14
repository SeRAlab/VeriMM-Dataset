`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg SEL0;
    reg SEL1;
    wire [3:0] Y;

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
        .SEL0(SEL0),
        .SEL1(SEL1),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select A (SEL1=0, SEL0=0)", test_num);
        A = 4'h5; B = 4'hA; C = 4'hF; D = 4'h0;
        SEL1 = 1'b0; SEL0 = 1'b0;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select B (SEL1=0, SEL0=1)", test_num);
        A = 4'h1; B = 4'hB; C = 4'h2; D = 4'h3;
        SEL1 = 1'b0; SEL0 = 1'b1;
        #1;

        check_outputs(4'hB);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select C (SEL1=1, SEL0=0)", test_num);
        A = 4'hE; B = 4'hD; C = 4'hC; D = 4'hB;
        SEL1 = 1'b1; SEL0 = 1'b0;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select D (SEL1=1, SEL0=1)", test_num);
        A = 4'h7; B = 4'h8; C = 4'h9; D = 4'hD;
        SEL1 = 1'b1; SEL0 = 1'b1;
        #1;

        check_outputs(4'hD);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs 0xF, select A", test_num);
        A = 4'hF; B = 4'hF; C = 4'hF; D = 4'hF;
        SEL1 = 1'b0; SEL0 = 1'b0;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Change input B while SEL=01", test_num);
        A = 4'h0; B = 4'h6; C = 4'h0; D = 4'h0;
        SEL1 = 1'b0; SEL0 = 1'b1;
        #1;

        check_outputs(4'h6);
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
        input [3:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
