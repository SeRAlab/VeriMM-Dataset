`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [32:0] mem;
    wire [32:0] wave;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mem(mem),
        .wave(wave)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            mem = 33'h0_0000_0000;
            #1;

            check_outputs(33'h0_0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            mem = 33'h1_FFFF_FFFF;
            #1;

            check_outputs(33'h1_FFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle Bit 0", test_num);
            mem = 33'h0_0000_0001;
            #1;

            check_outputs(33'h0_0000_0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle Bit 32", test_num);
            mem = 33'h1_0000_0000;
            #1;

            check_outputs(33'h1_0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Pattern A", test_num);
            mem = 33'h0_AAAA_AAAA;
            #1;

            check_outputs(33'h0_AAAA_AAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Pattern B", test_num);
            mem = 33'h1_5555_5555;
            #1;

            check_outputs(33'h1_5555_5555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking Bit (Middle)", test_num);
            mem = 33'h0_0001_0000;
            #1;

            check_outputs(33'h0_0001_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Hex Pattern 1", test_num);
            mem = 33'h1_DEADC_0DEB;
            #1;

            check_outputs(33'h1_DEADC_0DEB);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Hex Pattern 2", test_num);
            mem = 33'h0_1234_5678;
            #1;

            check_outputs(33'h0_1234_5678);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Values (Upper Limit)", test_num);
            mem = 33'h1_8000_0000;
            #1;

            check_outputs(33'h1_8000_0000);
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
        input [32:0] expected_wave;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_wave === (expected_wave ^ wave ^ expected_wave)) begin
                $display("PASS");
                $display("  Outputs: wave=%h",
                         wave);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wave=%h",
                         expected_wave);
                $display("  Got:      wave=%h",
                         wave);
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
