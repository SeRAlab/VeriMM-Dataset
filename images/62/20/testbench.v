`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    reg sel;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sel(sel),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select A (simple value)", test_num);
            a = 64'hAAAA_AAAA_AAAA_AAAA;
            b = 64'h5555_5555_5555_5555;
            sel = 0;
            #1;

            check_outputs(64'hAAAA_AAAA_AAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select B (simple value)", test_num);
            a = 64'hAAAA_AAAA_AAAA_AAAA;
            b = 64'h5555_5555_5555_5555;
            sel = 1;
            #1;

            check_outputs(64'h5555_5555_5555_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select A (All Fs)", test_num);
            a = 64'hFFFF_FFFF_FFFF_FFFF;
            b = 64'h0000_0000_0000_0000;
            sel = 0;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select B (All Fs)", test_num);
            a = 64'h0000_0000_0000_0000;
            b = 64'hFFFF_FFFF_FFFF_FFFF;
            sel = 1;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select A (Walking bit pattern)", test_num);
            a = 64'h1234_5678_9ABC_DEF0;
            b = 64'hFEDC_BA98_7654_3210;
            sel = 0;
            #1;

            check_outputs(64'h1234_5678_9ABC_DEF0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select B (Walking bit pattern)", test_num);
            a = 64'h1234_5678_9ABC_DEF0;
            b = 64'hFEDC_BA98_7654_3210;
            sel = 1;
            #1;

            check_outputs(64'hFEDC_BA98_7654_3210);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select A (Zeros)", test_num);
            a = 64'h0000_0000_0000_0000;
            b = 64'hFFFF_FFFF_FFFF_FFFF;
            sel = 0;
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select B (Zeros)", test_num);
            a = 64'hFFFF_FFFF_FFFF_FFFF;
            b = 64'h0000_0000_0000_0000;
            sel = 1;
            #1;

            check_outputs(64'h0000_0000_0000_0000);
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
        input [63:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
