`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg flag;
    reg [63:0] in1;
    reg [63:0] in2;
    wire [63:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .flag(flag),
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            in1 = 64'hAAAA_AAAA_AAAA_AAAA;
            in2 = 64'h5555_5555_5555_5555;
            flag = 1;
            $display("Test %0d: flag=1, selecting in1", test_num);
            #1;

            check_outputs(in1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in1 = 64'hAAAA_AAAA_AAAA_AAAA;
            in2 = 64'h5555_5555_5555_5555;
            flag = 0;
            $display("Test %0d: flag=0, selecting in2", test_num);
            #1;

            check_outputs(in2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in1 = 64'hFFFF_FFFF_FFFF_FFFF;
            in2 = 64'h0000_0000_0000_0000;
            flag = 1;
            $display("Test %0d: Boundary check - flag=1, All ones", test_num);
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in1 = 64'hFFFF_FFFF_FFFF_FFFF;
            in2 = 64'h0000_0000_0000_0000;
            flag = 0;
            $display("Test %0d: Boundary check - flag=0, All zeros", test_num);
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in1 = 64'h1234_5678_9ABC_DEF0;
            in2 = 64'hFEDC_BA98_7654_3210;
            flag = 1;
            $display("Test %0d: Pattern check - flag=1", test_num);
            #1;

            check_outputs(64'h1234_5678_9ABC_DEF0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in1 = 64'h1234_5678_9ABC_DEF0;
            in2 = 64'hFEDC_BA98_7654_3210;
            flag = 0;
            $display("Test %0d: Pattern check - flag=0", test_num);
            #1;

            check_outputs(64'hFEDC_BA98_7654_3210);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in1 = 64'h0;
            in2 = 64'hFFFF_FFFF_FFFF_FFFF;
            flag = 1;
            $display("Test %0d: Toggle check - flag=1", test_num);
            #1;

            check_outputs(64'h0);
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
        input [63:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
