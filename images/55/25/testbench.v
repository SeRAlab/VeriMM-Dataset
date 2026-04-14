`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    wire parity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .parity(parity)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 16'h0000;
            $display("Test %0d: All zeros (in=0x0000)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 16'h0001;
            $display("Test %0d: Single bit set (in=0x0001)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 16'h0003;
            $display("Test %0d: Two bits set (in=0x0003)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 16'h0007;
            $display("Test %0d: Three bits set (in=0x0007)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 16'hFFFF;
            $display("Test %0d: All bits set (in=0xFFFF)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 16'h7FFF;
            $display("Test %0d: Fifteen bits set (in=0x7FFF)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 16'hAAAA;
            $display("Test %0d: Alternating pattern (in=0xAAAA)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in = 16'h1111;
            $display("Test %0d: Sparse bits (in=0x1111)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in = 16'h1234;
            $display("Test %0d: Pattern 0x1234", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in = 16'hCAFE;
            $display("Test %0d: Pattern 0xCAFE", test_num);
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
        input expected_parity;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_parity === (expected_parity ^ parity ^ expected_parity)) begin
                $display("PASS");
                $display("  Outputs: parity=%b",
                         parity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parity=%b",
                         expected_parity);
                $display("  Got:      parity=%b",
                         parity);
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
