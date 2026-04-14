`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] i_16;
    wire [31:0] o_32;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_16(i_16),
        .o_32(o_32)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Zero (0x0000)", test_num);
            i_16 = 16'h0000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Positive Signed (0x7FFF)", test_num);
            i_16 = 16'h7FFF;
            #1;

            check_outputs(32'h00007FFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Min Negative Signed (0x8000)", test_num);
            i_16 = 16'h8000;
            #1;

            check_outputs(32'hFFFF8000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative One (0xFFFF)", test_num);
            i_16 = 16'hFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Positive (0x1234)", test_num);
            i_16 = 16'h1234;
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Negative (0xABCD)", test_num);
            i_16 = 16'hABCD;
            #1;

            check_outputs(32'hFFFFABCD);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Smallest Positive (0x0001)", test_num);
            i_16 = 16'h0001;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative near Zero (0xFFFE)", test_num);
            i_16 = 16'hFFFE;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pattern 0x5555", test_num);
            i_16 = 16'h5555;
            #1;

            check_outputs(32'h00005555);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pattern 0xAAAA", test_num);
            i_16 = 16'hAAAA;
            #1;

            check_outputs(32'hFFFFAAAA);
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
        input [31:0] expected_o_32;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_32 === (expected_o_32 ^ o_32 ^ expected_o_32)) begin
                $display("PASS");
                $display("  Outputs: o_32=%h",
                         o_32);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_32=%h",
                         expected_o_32);
                $display("  Got:      o_32=%h",
                         o_32);
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
