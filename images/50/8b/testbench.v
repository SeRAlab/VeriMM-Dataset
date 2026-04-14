`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] D_0;
    reg [7:0] D_1;
    reg MS;
    wire [7:0] D_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D_0(D_0),
        .D_1(D_1),
        .MS(MS),
        .D_out(D_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D_0 with simple values", test_num);
            D_0 = 8'hA5;
            D_1 = 8'h5A;
            MS = 1'b0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D_1 with simple values", test_num);
            D_0 = 8'hA5;
            D_1 = 8'h5A;
            MS = 1'b1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D_0 (All Ones vs All Zeros)", test_num);
            D_0 = 8'hFF;
            D_1 = 8'h00;
            MS = 1'b0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D_1 (All Ones vs All Zeros)", test_num);
            D_0 = 8'hFF;
            D_1 = 8'h00;
            MS = 1'b1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D_0 with alternating patterns", test_num);
            D_0 = 8'hAA;
            D_1 = 8'h55;
            MS = 1'b0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D_1 with alternating patterns", test_num);
            D_0 = 8'hAA;
            D_1 = 8'h55;
            MS = 1'b1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check robustness with MS = X (should default to D_0)", test_num);
            D_0 = 8'h12;
            D_1 = 8'h34;
            MS = 1'bx;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High-order bits check on D_1", test_num);
            D_0 = 8'h0F;
            D_1 = 8'hF0;
            MS = 1'b1;
            #1;

            check_outputs(8'hF0);
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
        input [7:0] expected_D_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D_out === (expected_D_out ^ D_out ^ expected_D_out)) begin
                $display("PASS");
                $display("  Outputs: D_out=%h",
                         D_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D_out=%h",
                         expected_D_out);
                $display("  Got:      D_out=%h",
                         D_out);
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
