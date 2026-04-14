`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] I;
    wire [1:0] D;
    wire V;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I(I),
        .D(D),
        .V(V)
    );
    task testcase001;

    begin
        test_num = 1;
        I = 4'b0000;
        $display("Testcase %0d: All inputs zero", test_num);
        #1;

        check_outputs(2'b00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        I = 4'b0001;
        $display("Testcase %0d: Only I[0] active", test_num);
        #1;

        check_outputs(2'b00, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        I = 4'b0010;
        $display("Testcase %0d: Only I[1] active", test_num);
        #1;

        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        I = 4'b0100;
        $display("Testcase %0d: Only I[2] active", test_num);
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        I = 4'b1000;
        $display("Testcase %0d: Only I[3] active", test_num);
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        I = 4'b1001;
        $display("Testcase %0d: I[3] and I[0] active", test_num);
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        I = 4'b0111;
        $display("Testcase %0d: I[2], I[1], I[0] active", test_num);
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        I = 4'b0011;
        $display("Testcase %0d: I[1] and I[0] active", test_num);
        #1;

        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        I = 4'b1111;
        $display("Testcase %0d: All inputs active", test_num);
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        I = 4'b1100;
        $display("Testcase %0d: I[3] and I[2] active", test_num);
        #1;

        check_outputs(2'b11, 1'b1);
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
        input [1:0] expected_D;
        input expected_V;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D === (expected_D ^ D ^ expected_D) &&
                expected_V === (expected_V ^ V ^ expected_V)) begin
                $display("PASS");
                $display("  Outputs: D=%h, V=%b",
                         D, V);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h, V=%b",
                         expected_D, expected_V);
                $display("  Got:      D=%h, V=%b",
                         D, V);
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
