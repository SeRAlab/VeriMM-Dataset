`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] divident;
    reg [31:0] divisor;
    wire [31:0] quotient;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .divident(divident),
        .divisor(divisor),
        .quotient(quotient)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 1.0 / 1.0", test_num);
        divident = 32'h3f800000;
        divisor  = 32'h3f800000;
        #1;

        check_outputs(32'h3f800000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 4.0 / 2.0", test_num);
        divident = 32'h40800000;
        divisor  = 32'h40000000;
        #1;

        check_outputs(32'h40000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 10.0 / -2.0", test_num);
        divident = 32'h41200000;
        divisor  = 32'hc0000000;
        #1;

        check_outputs(32'hc0a00000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: -8.0 / -4.0", test_num);
        divident = 32'hc1000000;
        divisor  = 32'hc0800000;
        #1;

        check_outputs(32'h40000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 0.0 / 5.0", test_num);
        divident = 32'h00000000;
        divisor  = 32'h40a00000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 1.0 / 0.0", test_num);
        divident = 32'h3f800000;
        divisor  = 32'h00000000;
        #1;

        check_outputs(32'h7f800000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 1.0 / 4.0", test_num);
        divident = 32'h3f800000;
        divisor  = 32'h40800000;
        #1;

        check_outputs(32'h3e800000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 64.0 / 0.5", test_num);
        divident = 32'h42800000;
        divisor  = 32'h3f000000;
        #1;

        check_outputs(32'h43000000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 2^20 / 2^10", test_num);
        divident = 32'h49800000;
        divisor  = 32'h44800000;
        #1;

        check_outputs(32'h44800000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: -1.0 / 1.0", test_num);
        divident = 32'hbf800000;
        divisor  = 32'h3f800000;
        #1;

        check_outputs(32'hbf800000);
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
        input [31:0] expected_quotient;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h",
                         quotient);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h",
                         expected_quotient);
                $display("  Got:      quotient=%h",
                         quotient);
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
