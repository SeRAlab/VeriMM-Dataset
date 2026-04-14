`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg f;
    reg g;
    reg u;
    reg y;
    wire m;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .f(f),
        .g(g),
        .u(u),
        .y(y),
        .m(m)
    );
    task testcase001;

    begin
        $display("Test Case 001: gfuy = 0000");
        g = 0; f = 0; u = 0; y = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: gfuy = 0001");
        g = 0; f = 0; u = 0; y = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: gfuy = 0010");
        g = 0; f = 0; u = 1; y = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: gfuy = 0011");
        g = 0; f = 0; u = 1; y = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: gfuy = 0100");
        g = 0; f = 1; u = 0; y = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: gfuy = 0101");
        g = 0; f = 1; u = 0; y = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: gfuy = 0110");
        g = 0; f = 1; u = 1; y = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: gfuy = 0111");
        g = 0; f = 1; u = 1; y = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        $display("Test Case 009: gfuy = 1000");
        g = 1; f = 0; u = 0; y = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        $display("Test Case 010: gfuy = 1001");
        g = 1; f = 0; u = 0; y = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase011;

    begin
        $display("Test Case 011: gfuy = 1010");
        g = 1; f = 0; u = 1; y = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase012;

    begin
        $display("Test Case 012: gfuy = 1011");
        g = 1; f = 0; u = 1; y = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase013;

    begin
        $display("Test Case 013: gfuy = 1100");
        g = 1; f = 1; u = 0; y = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase014;

    begin
        $display("Test Case 014: gfuy = 1101");
        g = 1; f = 1; u = 0; y = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase015;

    begin
        $display("Test Case 015: gfuy = 1110");
        g = 1; f = 1; u = 1; y = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase016;

    begin
        $display("Test Case 016: gfuy = 1111");
        g = 1; f = 1; u = 1; y = 1;
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_m;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_m === (expected_m ^ m ^ expected_m)) begin
                $display("PASS");
                $display("  Outputs: m=%b",
                         m);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m=%b",
                         expected_m);
                $display("  Got:      m=%b",
                         m);
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
