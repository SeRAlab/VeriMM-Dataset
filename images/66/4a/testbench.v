`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] zIn16;
    wire [31:0] zOut32;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .zIn16(zIn16),
        .zOut32(zOut32)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Zero", test_num);
            zIn16 = 16'h0000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input All Ones", test_num);
            zIn16 = 16'hFFFF;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input MSB set (check for zero extension vs sign extension)", test_num);
            zIn16 = 16'h8000;
            #1;

            check_outputs(32'h00008000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Pattern 1234", test_num);
            zIn16 = 16'h1234;
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Alternating Bits AAAA", test_num);
            zIn16 = 16'hAAAA;
            #1;

            check_outputs(32'h0000AAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Alternating Bits 5555", test_num);
            zIn16 = 16'h5555;
            #1;

            check_outputs(32'h00005555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Pattern BEEF", test_num);
            zIn16 = 16'hBEEF;
            #1;

            check_outputs(32'h0000BEEF);
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
        input [31:0] expected_zOut32;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_zOut32 === (expected_zOut32 ^ zOut32 ^ expected_zOut32)) begin
                $display("PASS");
                $display("  Outputs: zOut32=%h",
                         zOut32);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: zOut32=%h",
                         expected_zOut32);
                $display("  Got:      zOut32=%h",
                         zOut32);
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
