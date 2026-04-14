`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [31:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .p(p)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 16'd0;
            b = 16'd0;
            $display("Test %0d: 0 * 0", test_num);
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 16'd1;
            b = 16'd1;
            $display("Test %0d: 1 * 1", test_num);
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 16'hFFFF;
            b = 16'd0;
            $display("Test %0d: 65535 * 0", test_num);
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 16'hFFFF;
            b = 16'd1;
            $display("Test %0d: 65535 * 1", test_num);
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 16'd256;
            b = 16'd256;
            $display("Test %0d: 256 * 256 (Power of 2 check)", test_num);
            #1;

            check_outputs(32'd65536);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 16'hFFFF;
            b = 16'hFFFF;
            $display("Test %0d: 65535 * 65535 (Max unsigned check)", test_num);
            #1;

            check_outputs(32'hFFFE0001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 16'd123;
            b = 16'd456;
            $display("Test %0d: 123 * 456", test_num);
            #1;

            check_outputs(32'd56088);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 16'h8000;
            b = 16'd2;
            $display("Test %0d: 32768 * 2", test_num);
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 16'd1000;
            b = 16'd1000;
            $display("Test %0d: 1000 * 1000", test_num);
            #1;

            check_outputs(32'd1000000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 16'hABCD;
            b = 16'h1234;
            $display("Test %0d: 0xABCD * 0x1234", test_num);
            #1;

            check_outputs(32'h0C389364);
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
        input [31:0] expected_p;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
