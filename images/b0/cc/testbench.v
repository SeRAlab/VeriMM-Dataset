`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] pc_in;
    wire [31:0] pc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pc_in(pc_in),
        .pc_out(pc_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Incrementing Zero", test_num);
            pc_in = 32'h00000000;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Incrementing small value", test_num);
            pc_in = 32'h0000000F;
            #1;

            check_outputs(32'h00000010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Maximum value wrap-around (Overflow)", test_num);
            pc_in = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Middle carry chain (16-bit boundary)", test_num);
            pc_in = 32'h0000FFFF;
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Incrementing a large value", test_num);
            pc_in = 32'h12345678;
            #1;

            check_outputs(32'h12345679);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Signed bit boundary", test_num);
            pc_in = 32'h7FFFFFFF;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Alternating bit pattern A", test_num);
            pc_in = 32'hAAAAAAAA;
            #1;

            check_outputs(32'hAAAAAAAB);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Alternating bit pattern 5", test_num);
            pc_in = 32'h55555555;
            #1;

            check_outputs(32'h55555556);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Near wrap-around", test_num);
            pc_in = 32'hFFFFFFFE;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Random memory address", test_num);
            pc_in = 32'h00400000;
            #1;

            check_outputs(32'h00400001);
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
        input [31:0] expected_pc_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pc_out === (expected_pc_out ^ pc_out ^ expected_pc_out)) begin
                $display("PASS");
                $display("  Outputs: pc_out=%h",
                         pc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_out=%h",
                         expected_pc_out);
                $display("  Got:      pc_out=%h",
                         pc_out);
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
