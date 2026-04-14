`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire notEqual;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .notEqual(notEqual)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A and B are both zero", test_num);
        A = 32'h00000000;
        B = 32'h00000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A and B are both all ones", test_num);
        A = 32'hFFFFFFFF;
        B = 32'hFFFFFFFF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A and B differ only at the LSB", test_num);
        A = 32'h00000000;
        B = 32'h00000001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A and B differ only at the MSB", test_num);
        A = 32'h80000000;
        B = 32'h00000000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A and B are bitwise inverses", test_num);
        A = 32'hAAAAAAAA;
        B = 32'h55555555;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A and B match a complex pattern", test_num);
        A = 32'h12345678;
        B = 32'h12345678;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A and B differ by one bit in the middle", test_num);
        A = 32'h12345678;
        B = 32'h12345E78;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A is all ones, B is all zeros", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A and B are random walk patterns", test_num);
        A = 32'hDEADBEEF;
        B = 32'hDEADBEEF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Minimal difference walk", test_num);
        A = 32'h00000100;
        B = 32'h00000000;
        #1;

        check_outputs(1'b1);
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
        input expected_notEqual;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_notEqual === (expected_notEqual ^ notEqual ^ expected_notEqual)) begin
                $display("PASS");
                $display("  Outputs: notEqual=%b",
                         notEqual);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: notEqual=%b",
                         expected_notEqual);
                $display("  Got:      notEqual=%b",
                         notEqual);
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
