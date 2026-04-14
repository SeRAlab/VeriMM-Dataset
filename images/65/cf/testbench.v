`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data;
    reg [31:0] key;
    wire [31:0] encrypted_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .key(key),
        .encrypted_data(encrypted_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (Identity Check)", test_num);
            data = 32'h00000000;
            key  = 32'h00000000;
            #1;

            check_outputs(calculate_expected(data, key));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key with No Shift (XOR and Permute Only)", test_num);
            data = 32'hAABBCCDD;
            key  = 32'h00000000;
            #1;

            check_outputs(calculate_expected(data, key));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key with Shift Amounts", test_num);

            data = 32'h00000000;
            key  = 32'h01020304;
            #1;

            check_outputs(calculate_expected(data, key));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            data = 32'hFFFFFFFF;
            key  = 32'hFFFFFFFF;
            #1;

            check_outputs(calculate_expected(data, key));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Key Values (Modulo Shift Test)", test_num);

            data = 32'h12345678;
            key  = 32'h08090A0B;
            #1;

            check_outputs(calculate_expected(data, key));
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Data and Key", test_num);
            data = 32'h5A5A5A5A;
            key  = 32'hC3C3C3C3;
            #1;

            check_outputs(calculate_expected(data, key));
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
        input [31:0] expected_encrypted_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encrypted_data === (expected_encrypted_data ^ encrypted_data ^ expected_encrypted_data)) begin
                $display("PASS");
                $display("  Outputs: encrypted_data=%h",
                         encrypted_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encrypted_data=%h",
                         expected_encrypted_data);
                $display("  Got:      encrypted_data=%h",
                         encrypted_data);
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
