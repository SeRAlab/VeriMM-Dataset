`timescale 1ns/1ps

module xor_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg enable;
    reg reset;
    wire [7:0] xor_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    xor_module dut (
        .a(a),
        .b(b),
        .enable(enable),
        .reset(reset),
        .xor_result(xor_result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset functionality", test_num);

            reset = 1;
            enable = 1;
            a = 8'hFF;
            b = 8'hAA;
            #10;
            #1;

            check_outputs(8'h00);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic XOR (0x55 ^ 0xAA)", test_num);

            reset = 1; #5; reset = 0;

            a = 8'h55;
            b = 8'hAA;
            enable = 1;
            #10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: XOR same values (0xFF ^ 0xFF)", test_num);
            reset = 1; #5; reset = 0;
            a = 8'hFF;
            b = 8'hFF;
            enable = 1;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: XOR with zero (0x12 ^ 0x00)", test_num);
            reset = 1; #5; reset = 0;
            a = 8'h12;
            b = 8'h00;
            enable = 1;
            #10;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset priority over Enable", test_num);
            reset = 1; #5;
            a = 8'hFF;
            b = 8'h00;
            enable = 1;
            #10;
            #1;

            check_outputs(8'h00);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable low (Hold state/No update)", test_num);

            reset = 1; #5; reset = 0;

            a = 8'hA5;
            b = 8'h5A;
            enable = 0;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random Pattern (0x3C ^ 0xC3)", test_num);
            reset = 1; #5; reset = 0;
            a = 8'h3C;
            b = 8'hC3;
            enable = 1;
            #10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("xor_module Testbench");
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
        input [7:0] expected_xor_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_xor_result === (expected_xor_result ^ xor_result ^ expected_xor_result)) begin
                $display("PASS");
                $display("  Outputs: xor_result=%h",
                         xor_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: xor_result=%h",
                         expected_xor_result);
                $display("  Got:      xor_result=%h",
                         xor_result);
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
