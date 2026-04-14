`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] inA;
    wire [7:0] A;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inA(inA),
        .A(A)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All zeros input", test_num);
        inA = 8'h00;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All ones input", test_num);
        inA = 8'hFF;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Even bits set (0x55)", test_num);
        inA = 8'h55;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Odd bits set (0xAA)", test_num);
        inA = 8'hAA;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating nibbles (0xA5)", test_num);
        inA = 8'hA5;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Arbitrary pattern (0x12)", test_num);
        inA = 8'h12;
        #1;

        check_outputs(8'h47);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Walking bit (0x01)", test_num);
        inA = 8'h01;
        #1;

        check_outputs(8'h54);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Complex pattern (0xCA)", test_num);
        inA = 8'hCA;
        #1;

        check_outputs(8'h9F);
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
        input [7:0] expected_A;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A === (expected_A ^ A ^ expected_A)) begin
                $display("PASS");
                $display("  Outputs: A=%h",
                         A);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%h",
                         expected_A);
                $display("  Got:      A=%h",
                         A);
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
