`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    wire [31:0] RD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .RD(RD)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Index 0 (Address 0)", test_num);
            A = 32'h0000_0000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Index 1 (Address 4)", test_num);
            A = 32'h0000_0004;
            #1;

            check_outputs(32'h8c0b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Index 2 (Address 8)", test_num);
            A = 32'h0000_0008;
            #1;

            check_outputs(32'h8c0c0004);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Index 3 (Address 12)", test_num);
            A = 32'h0000_000C;
            #1;

            check_outputs(32'h016c0820);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Index 7 (Address 28)", test_num);
            A = 32'h0000_001C;
            #1;

            check_outputs(32'h03e00008);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Address Alignment (Address 7 -> Index 1)", test_num);
            A = 32'h0000_0007;
            #1;

            check_outputs(32'h8c0b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Upper Bits Ignore (Address 0x108 -> Index 2)", test_num);
            A = 32'h0000_0108;
            #1;

            check_outputs(32'h8c0c0004);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Index Default Check (Address 60 -> Index 15)", test_num);
            A = 32'h0000_003C;

            #1;


            check_outputs(32'h00000000);
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
        input [31:0] expected_RD;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RD === (expected_RD ^ RD ^ expected_RD)) begin
                $display("PASS");
                $display("  Outputs: RD=%h",
                         RD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RD=%h",
                         expected_RD);
                $display("  Got:      RD=%h",
                         RD);
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
