`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] d_d;
    reg [15:0] q;
    reg [10:0] radr_d;
    reg re_d;
    reg [10:0] wadr_d;
    reg we_d;
    wire [15:0] d;
    wire [15:0] q_d;
    wire [10:0] radr;
    wire re;
    wire [10:0] wadr;
    wire we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d_d(d_d),
        .q(q),
        .radr_d(radr_d),
        .re_d(re_d),
        .wadr_d(wadr_d),
        .we_d(we_d),
        .d(d),
        .q_d(q_d),
        .radr(radr),
        .re(re),
        .wadr(wadr),
        .we(we)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Write Operation Setup", test_num);
            we_d = 1'b1;
            d_d = 16'hABCD;
            wadr_d = 11'h123;
            re_d = 1'b0;
            radr_d = 11'h000;
            q = 16'h0000;

            #1;


            check_outputs(16'hABCD, 16'h0000, 11'h000, 1'b0, 11'h123, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Read Operation Setup", test_num);
            we_d = 1'b0;
            d_d = 16'h0000;
            wadr_d = 11'h000;
            re_d = 1'b1;
            radr_d = 11'h456;
            q = 16'h55AA;

            #1;


            check_outputs(16'h0000, 16'h55AA, 11'h456, 1'b1, 11'h000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simultaneous Read and Write Setup", test_num);
            we_d = 1'b1;
            d_d = 16'hFFFF;
            wadr_d = 11'h7FF;
            re_d = 1'b1;
            radr_d = 11'h3FF;
            q = 16'h1234;

            #1;


            check_outputs(16'hFFFF, 16'h1234, 11'h3FF, 1'b1, 11'h7FF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Boundary Test", test_num);
            we_d = 1'b0;
            d_d = 16'h0000;
            wadr_d = 11'h000;
            re_d = 1'b0;
            radr_d = 11'h000;
            q = 16'h0000;

            #1;


            check_outputs(16'h0000, 16'h0000, 11'h000, 1'b0, 11'h000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Pass-through Pattern Test", test_num);
            we_d = 1'b1;
            d_d = 16'hA5A5;
            wadr_d = 11'h5A5;
            re_d = 1'b1;
            radr_d = 11'h2AA;
            q = 16'hF0F0;

            #1;


            check_outputs(16'hA5A5, 16'hF0F0, 11'h2AA, 1'b1, 11'h5A5, 1'b1);
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
        input [15:0] expected_d;
        input [15:0] expected_q_d;
        input [10:0] expected_radr;
        input expected_re;
        input [10:0] expected_wadr;
        input expected_we;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d === (expected_d ^ d ^ expected_d) &&
                expected_q_d === (expected_q_d ^ q_d ^ expected_q_d) &&
                expected_radr === (expected_radr ^ radr ^ expected_radr) &&
                expected_re === (expected_re ^ re ^ expected_re) &&
                expected_wadr === (expected_wadr ^ wadr ^ expected_wadr) &&
                expected_we === (expected_we ^ we ^ expected_we)) begin
                $display("PASS");
                $display("  Outputs: d=%h, q_d=%h, radr=%h, re=%b, wadr=%h, we=%b",
                         d, q_d, radr, re, wadr, we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d=%h, q_d=%h, radr=%h, re=%b, wadr=%h, we=%b",
                         expected_d, expected_q_d, expected_radr, expected_re, expected_wadr, expected_we);
                $display("  Got:      d=%h, q_d=%h, radr=%h, re=%b, wadr=%h, we=%b",
                         d, q_d, radr, re, wadr, we);
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
