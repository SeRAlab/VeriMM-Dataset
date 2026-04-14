`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] r;
    wire [63:0] str;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .r(r),
        .str(str)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Register x0 (zero)", test_num);
            r = 5'd0;

            #1;


            check_outputs(64'h000000007a65726f);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Register x1 (ra)", test_num);
            r = 5'd1;

            #1;


            check_outputs(64'h0000000000007261);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Register x2 (sp)", test_num);
            r = 5'd2;

            #1;


            check_outputs(64'h0000000000007370);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Register x10 (a0)", test_num);
            r = 5'd10;

            #1;


            check_outputs(64'h0000000000006130);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Register x15 (a5)", test_num);
            r = 5'd15;

            #1;


            check_outputs(64'h0000000000006135);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Register x31 (t6)", test_num);
            r = 5'd31;

            #1;


            check_outputs(64'h0000000000007436);
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
        input [63:0] expected_str;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_str === (expected_str ^ str ^ expected_str)) begin
                $display("PASS");
                $display("  Outputs: str=%h",
                         str);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: str=%h",
                         expected_str);
                $display("  Got:      str=%h",
                         str);
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
