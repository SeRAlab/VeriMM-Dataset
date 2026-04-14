`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg E;
    wire [15:0] C;
    wire OverflowFlag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .E(E),
        .C(C),
        .OverflowFlag(OverflowFlag)
    );
    task testcase001;

    begin
        A = 16'hAAAA;
        B = 16'h5555;
        E = 1'b1;
        #1;

        check_outputs(16'hFFFF, 1'b0);
    end
        endtask

    task testcase002;

    begin
        A = 16'hFFFF;
        B = 16'hFFFF;
        E = 1'b0;
        #1;

        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase003;

    begin
        A = 16'h1234;
        B = 16'h4321;
        E = 1'b1;
        #1;

        check_outputs(16'h5335, 1'b0);
    end
        endtask

    task testcase004;

    begin
        A = 16'h0000;
        B = 16'h0000;
        E = 1'b1;
        #1;

        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase005;

    begin
        A = 16'hFFFF;
        B = 16'hFFFF;
        E = 1'b1;
        #1;

        check_outputs(16'hFFFF, 1'b0);
    end
        endtask

    task testcase006;

    begin
        A = 16'hABCD;
        B = 16'h0000;
        E = 1'b1;
        #1;

        check_outputs(16'hABCD, 1'b0);
    end
        endtask

    task testcase007;

    begin
        A = 16'hF0F0;
        B = 16'h0F0F;
        E = 1'b0;

        #1;


        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase008;

    begin
        A = 16'hF0F0;
        B = 16'h0F0F;
        E = 1'b1;
        #1;

        check_outputs(16'hFFFF, 1'b0);
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
        input [15:0] expected_C;
        input expected_OverflowFlag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_OverflowFlag === (expected_OverflowFlag ^ OverflowFlag ^ expected_OverflowFlag)) begin
                $display("PASS");
                $display("  Outputs: C=%h, OverflowFlag=%b",
                         C, OverflowFlag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, OverflowFlag=%b",
                         expected_C, expected_OverflowFlag);
                $display("  Got:      C=%h, OverflowFlag=%b",
                         C, OverflowFlag);
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
