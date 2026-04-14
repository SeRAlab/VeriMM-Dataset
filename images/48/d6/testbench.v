`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [31:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .o(o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero multiplication (0 * 0)", test_num);
            a = 16'h0000;
            b = 16'h0000;
            #1;

            check_outputs(32'h00000000);

            test_num = test_num + 1;
            $display("Test Case %0d: Zero multiplication (1234 * 0)", test_num);
            a = 16'h1234;
            b = 16'h0000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity multiplication (1 * 1)", test_num);
            a = 16'h0001;
            b = 16'h0001;
            #1;

            check_outputs(32'h00000001);

            test_num = test_num + 1;
            $display("Test Case %0d: Identity multiplication (0xFFFF * 1)", test_num);
            a = 16'hFFFF;
            b = 16'h0001;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum values (0xFFFF * 0xFFFF)", test_num);
            a = 16'hFFFF;
            b = 16'hFFFF;

            #1;


            check_outputs(32'hFFFE0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Powers of 2 (256 * 256)", test_num);
            a = 16'd256;
            b = 16'd256;
            #1;

            check_outputs(32'd65536);

            test_num = test_num + 1;
            $display("Test Case %0d: Powers of 2 (1024 * 32)", test_num);
            a = 16'd1024;
            b = 16'd32;
            #1;

            check_outputs(32'd32768);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Hex (0xABCD * 0x1234)", test_num);
            a = 16'hABCD;
            b = 16'h1234;

            #1;


            check_outputs(32'h0C35C124);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Prime multiplication (7919 * 6551)", test_num);
            a = 16'd7919;
            b = 16'd6551;
            #1;

            check_outputs(32'd51877369);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Middle range (0x8000 * 0x8000)", test_num);
            a = 16'h8000;
            b = 16'h8000;

            #1;


            check_outputs(32'h40000000);
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
        input [31:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
