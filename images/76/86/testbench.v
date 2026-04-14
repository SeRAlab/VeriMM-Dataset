`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg infL;
    reg infR;
    reg reset_n;
    wire md1;
    wire md2;
    wire md3;
    wire md4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .infL(infL),
        .infR(infR),
        .reset_n(reset_n),
        .md1(md1),
        .md2(md2),
        .md3(md3),
        .md4(md4)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Forward (infL=0, infR=0)", test_num);

            reset_n = 0; infL = 0; infR = 0;
            #15 reset_n = 1;

            infL = 0; infR = 0;
            @(posedge clk);
            #1;

            check_outputs(1, 0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Right Turn (infL=1, infR=0)", test_num);

            reset_n = 0;
            #15 reset_n = 1;

            infL = 1; infR = 0;
            @(posedge clk);
            #1;

            check_outputs(1, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Left Turn (infL=0, infR=1)", test_num);

            reset_n = 0;
            #15 reset_n = 1;

            infL = 0; infR = 1;
            @(posedge clk);
            #1;

            check_outputs(0, 1, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Stop (infL=1, infR=1)", test_num);

            reset_n = 0;
            #15 reset_n = 1;

            infL = 1; infR = 1;
            @(posedge clk);
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Reset State Verification", test_num);

            reset_n = 0; infL = 0; infR = 0;
            @(posedge clk);
            #1;

            check_outputs(0, 0, 0, 0);
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
        input expected_md1;
        input expected_md2;
        input expected_md3;
        input expected_md4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_md1 === (expected_md1 ^ md1 ^ expected_md1) &&
                expected_md2 === (expected_md2 ^ md2 ^ expected_md2) &&
                expected_md3 === (expected_md3 ^ md3 ^ expected_md3) &&
                expected_md4 === (expected_md4 ^ md4 ^ expected_md4)) begin
                $display("PASS");
                $display("  Outputs: md1=%b, md2=%b, md3=%b, md4=%b",
                         md1, md2, md3, md4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: md1=%b, md2=%b, md3=%b, md4=%b",
                         expected_md1, expected_md2, expected_md3, expected_md4);
                $display("  Got:      md1=%b, md2=%b, md3=%b, md4=%b",
                         md1, md2, md3, md4);
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
