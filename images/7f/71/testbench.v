`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] R1;
    reg [7:0] R2;
    wire [15:0] outXor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .R1(R1),
        .R2(R2),
        .outXor(outXor)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (0x00 ^ 0x00)", test_num);
            R1 = 8'h00;
            R2 = 8'h00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identical Inputs (0xFF ^ 0xFF)", test_num);
            R1 = 8'hFF;
            R2 = 8'hFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complementary bits (0xAA ^ 0x55)", test_num);
            R1 = 8'hAA;
            R2 = 8'h55;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity (0x12 ^ 0x00)", test_num);
            R1 = 8'h12;
            R2 = 8'h00;
            #1;

            check_outputs(16'h0012);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Inverse (0x33 ^ 0xFF)", test_num);
            R1 = 8'h33;
            R2 = 8'hFF;
            #1;

            check_outputs(16'h00CC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern 1 (0x12 ^ 0x34)", test_num);
            R1 = 8'h12;
            R2 = 8'h34;
            #1;

            check_outputs(16'h0026);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern 2 (0xDE ^ 0xAD)", test_num);
            R1 = 8'hDE;
            R2 = 8'hAD;
            #1;

            check_outputs(16'h0073);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating nibbles (0xF0 ^ 0x0F)", test_num);
            R1 = 8'hF0;
            R2 = 8'h0F;
            #1;

            check_outputs(16'h00FF);
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
        input [15:0] expected_outXor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outXor === (expected_outXor ^ outXor ^ expected_outXor)) begin
                $display("PASS");
                $display("  Outputs: outXor=%h",
                         outXor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outXor=%h",
                         expected_outXor);
                $display("  Got:      outXor=%h",
                         outXor);
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
