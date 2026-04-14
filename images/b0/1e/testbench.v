`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg [31:0] rs;
    reg [31:0] rt;
    wire eq;
    wire eqz;
    wire gez;
    wire gtz;
    wire lez;
    wire ltz;
    wire ne;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .en(en),
        .rs(rs),
        .rt(rt),
        .eq(eq),
        .eqz(eqz),
        .gez(gez),
        .gtz(gtz),
        .lez(lez),
        .ltz(ltz),
        .ne(ne)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Disabled (en=0)", test_num);
            en = 0;
            rs = 32'h0000_000A;
            rt = 32'h0000_000A;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: rs=0, rt=0 (en=1)", test_num);
            en = 1;
            rs = 32'h0000_0000;
            rt = 32'h0000_0000;

            #1;


            check_outputs(1, 1, 1, 0, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: rs=positive, rt=same positive (en=1)", test_num);
            en = 1;
            rs = 32'd100;
            rt = 32'd100;

            #1;


            check_outputs(1, 0, 1, 1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: rs=positive, rt=different positive (en=1)", test_num);
            en = 1;
            rs = 32'd100;
            rt = 32'd200;

            #1;


            check_outputs(0, 0, 1, 1, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: rs=negative, rt=same negative (en=1)", test_num);
            en = 1;
            rs = -32'd50;
            rt = -32'd50;

            #1;


            check_outputs(1, 0, 0, 0, 1, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: rs=negative, rt=positive (en=1)", test_num);
            en = 1;
            rs = -32'd50;
            rt = 32'd50;

            #1;


            check_outputs(0, 0, 0, 0, 1, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: rs=Max Positive (en=1)", test_num);
            en = 1;
            rs = 32'h7FFF_FFFF;
            rt = 32'h0000_0000;

            #1;


            check_outputs(0, 0, 1, 1, 0, 0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: rs=Max Negative (en=1)", test_num);
            en = 1;
            rs = 32'h8000_0000;
            rt = 32'h0000_0000;

            #1;


            check_outputs(0, 0, 0, 0, 1, 1, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: rs=0, rt=non-zero (en=1)", test_num);
            en = 1;
            rs = 32'h0000_0000;
            rt = 32'h1234_5678;

            #1;


            check_outputs(0, 1, 1, 0, 1, 0, 1);
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
        input expected_eq;
        input expected_eqz;
        input expected_gez;
        input expected_gtz;
        input expected_lez;
        input expected_ltz;
        input expected_ne;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eq === (expected_eq ^ eq ^ expected_eq) &&
                expected_eqz === (expected_eqz ^ eqz ^ expected_eqz) &&
                expected_gez === (expected_gez ^ gez ^ expected_gez) &&
                expected_gtz === (expected_gtz ^ gtz ^ expected_gtz) &&
                expected_lez === (expected_lez ^ lez ^ expected_lez) &&
                expected_ltz === (expected_ltz ^ ltz ^ expected_ltz) &&
                expected_ne === (expected_ne ^ ne ^ expected_ne)) begin
                $display("PASS");
                $display("  Outputs: eq=%b, eqz=%b, gez=%b, gtz=%b, lez=%b, ltz=%b, ne=%b",
                         eq, eqz, gez, gtz, lez, ltz, ne);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq=%b, eqz=%b, gez=%b, gtz=%b, lez=%b, ltz=%b, ne=%b",
                         expected_eq, expected_eqz, expected_gez, expected_gtz, expected_lez, expected_ltz, expected_ne);
                $display("  Got:      eq=%b, eqz=%b, gez=%b, gtz=%b, lez=%b, ltz=%b, ne=%b",
                         eq, eqz, gez, gtz, lez, ltz, ne);
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
