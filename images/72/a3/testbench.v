`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] n;
    wire [17:0] n_pow_5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .n(n),
        .n_pow_5(n_pow_5)
    );
    task testcase001;

    begin
        test_num = 1;
        n = 18'd0;
        #1;

        check_outputs(18'h00000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        n = 18'd1;
        #1;

        check_outputs(18'h00001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        n = 18'd2;
        #1;

        check_outputs(18'h00020);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        n = 18'd10;
        #1;

        check_outputs(18'h186A0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        n = 18'd12;
        #1;

        check_outputs(18'h3CC00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        n = 18'd20;
        #1;

        check_outputs(18'h0D400);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        n = 18'd100;
        #1;

        check_outputs(18'h3EC00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        n = 18'd123;
        #1;

        check_outputs(18'h3C4B);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        n = 18'h20000;
        #1;

        check_outputs(18'h00000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        n = 18'h3FFFF;
        #1;

        check_outputs(18'h3FFFF);
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
        input [17:0] expected_n_pow_5;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_n_pow_5 === (expected_n_pow_5 ^ n_pow_5 ^ expected_n_pow_5)) begin
                $display("PASS");
                $display("  Outputs: n_pow_5=%h",
                         n_pow_5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n_pow_5=%h",
                         expected_n_pow_5);
                $display("  Got:      n_pow_5=%h",
                         n_pow_5);
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
