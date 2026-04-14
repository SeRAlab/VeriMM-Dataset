`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A4;
    reg A5;
    reg A6;
    reg A7;
    reg [3:0] DIP;
    wire F;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A4(A4),
        .A5(A5),
        .A6(A6),
        .A7(A7),
        .DIP(DIP),
        .F(F)
    );
    task testcase001;

    begin
        test_num = 1;
        A7 = 0; A6 = 0; A5 = 0; A4 = 0;
        DIP = 4'b0000;
        $display("Testcase %0d: All Zeros Match", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A7 = 1; A6 = 1; A5 = 1; A4 = 1;
        DIP = 4'b1111;
        $display("Testcase %0d: All Ones Match", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A7 = 1; A6 = 0; A5 = 1; A4 = 0;
        DIP = 4'b1010;
        $display("Testcase %0d: Pattern 1010 Match", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A7 = 0; A6 = 1; A5 = 0; A4 = 1;
        DIP = 4'b0101;
        $display("Testcase %0d: Pattern 0101 Match", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A7 = 1; A6 = 1; A5 = 1; A4 = 0;
        DIP = 4'b1111;
        $display("Testcase %0d: Mismatch on Bit 0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A7 = 0; A6 = 1; A5 = 1; A4 = 1;
        DIP = 4'b1111;
        $display("Testcase %0d: Mismatch on Bit 3", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A7 = 1; A6 = 0; A5 = 1; A4 = 0;
        DIP = 4'b0101;
        $display("Testcase %0d: Full Pattern Inversion Mismatch", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A7 = 0; A6 = 0; A5 = 0; A4 = 1;
        DIP = 4'b0000;
        $display("Testcase %0d: DIP 0 vs A non-zero Mismatch", test_num);
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
        input expected_F;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F === (expected_F ^ F ^ expected_F)) begin
                $display("PASS");
                $display("  Outputs: F=%b",
                         F);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F=%b",
                         expected_F);
                $display("  Got:      F=%b",
                         F);
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
