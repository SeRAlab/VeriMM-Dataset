`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] q;
    reg [3:0] radr_d;
    reg re_d;
    wire [15:0] q_d;
    wire [3:0] radr;
    wire re;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .q(q),
        .radr_d(radr_d),
        .re_d(re_d),
        .q_d(q_d),
        .radr(radr),
        .re(re)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Active Read Operation", test_num);
        re_d = 1'b1;
        q = 16'hA5A5;
        radr_d = 4'hC;

        #1;


        check_outputs(16'hA5A5, 4'hC, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Read Disable Operation", test_num);
        re_d = 1'b0;
        q = 16'h5A5A;
        radr_d = 4'h3;
        #1;

        check_outputs(16'h5A5A, 4'h3, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: All-Ones Boundary Case", test_num);
        re_d = 1'b1;
        q = 16'hFFFF;
        radr_d = 4'hF;
        #1;

        check_outputs(16'hFFFF, 4'hF, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: All-Zeros Boundary Case", test_num);
        re_d = 1'b0;
        q = 16'h0000;
        radr_d = 4'h0;
        #1;

        check_outputs(16'h0000, 4'h0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Alternating Bits Pattern", test_num);
        re_d = 1'b1;
        q = 16'h1234;
        radr_d = 4'h7;
        #1;

        check_outputs(16'h1234, 4'h7, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Walking Address Pattern", test_num);
        re_d = 1'b1;
        q = 16'hBEEF;
        radr_d = 4'h8;
        #1;

        check_outputs(16'hBEEF, 4'h8, 1'b1);
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
        input [15:0] expected_q_d;
        input [3:0] expected_radr;
        input expected_re;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q_d === (expected_q_d ^ q_d ^ expected_q_d) &&
                expected_radr === (expected_radr ^ radr ^ expected_radr) &&
                expected_re === (expected_re ^ re ^ expected_re)) begin
                $display("PASS");
                $display("  Outputs: q_d=%h, radr=%h, re=%b",
                         q_d, radr, re);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_d=%h, radr=%h, re=%b",
                         expected_q_d, expected_radr, expected_re);
                $display("  Got:      q_d=%h, radr=%h, re=%b",
                         q_d, radr, re);
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
