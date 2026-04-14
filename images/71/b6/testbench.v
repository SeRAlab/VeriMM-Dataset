`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg clk;
    reg x;
    reg y;
    reg z;
    wire B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .clk(clk),
        .x(x),
        .y(y),
        .z(z),
        .B(B)
    );
    task testcase001;

    begin
        test_num = 1;
        x = 1'b0; y = 1'b0; z = 1'b1; A = 1'b0;
        #5; clk = 1; #5; clk = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        x = 1'b0; y = 1'b0; z = 1'b1; A = 1'b1;
        #5; clk = 1; #5; clk = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        x = 1'b1; y = 1'b0; z = 1'b1; A = 1'b1;
        #5; clk = 1; #5; clk = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        x = 1'b1; y = 1'b0; z = 1'b1; A = 1'b0;
        #5; clk = 1; #5; clk = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        x = 1'b0; y = 1'b1; z = 1'b1; A = 1'b1;
        #5; clk = 1; #5; clk = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        x = 1'b0; y = 1'b1; z = 1'b1; A = 1'b0;
        #5; clk = 1; #5; clk = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        x = 1'b0; y = 1'b0; z = 1'b0; A = 1'b1;
        #5; clk = 1; #5; clk = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        x = 1'b1; y = 1'b1; z = 1'b1; A = 1'b1;
        #5; clk = 1; #5; clk = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        x = 1'b1; y = 1'b1; z = 1'b0; A = 1'b1;
        #5; clk = 1; #5; clk = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        x = 1'b0; y = 1'b0; z = 1'b1; A = 1'b1;
        #5; clk = 1; #5; clk = 0;
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
        input expected_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B === (expected_B ^ B ^ expected_B)) begin
                $display("PASS");
                $display("  Outputs: B=%b",
                         B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%b",
                         expected_B);
                $display("  Got:      B=%b",
                         B);
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
