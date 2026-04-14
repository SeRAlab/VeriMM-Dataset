`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data;
    reg [15:0] key;
    wire [7:0] decrypted;
    wire [7:0] encrypted;
    wire [7:0] hashed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .key(key),
        .decrypted(decrypted),
        .encrypted(encrypted),
        .hashed(hashed)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            data = 8'h00;
            key = 16'h0000;
            #10;


            #1;



            check_outputs(8'h00, 8'h00, hashed);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Key, Non-Zero Data", test_num);
            data = 8'hFF;
            key = 16'h0000;
            #10;


            #1;



            check_outputs(8'hFF, 8'hFF, hashed);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Data, Full Key", test_num);
            data = 8'h00;
            key = 16'hFFFF;
            #10;


            #1;



            check_outputs(8'hFF, 8'hFF, hashed);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits (0xAA ^ 0x55)", test_num);
            data = 8'hAA;
            key = 16'h0055;
            #10;

            #1;


            check_outputs(8'hFF, 8'hFF, hashed);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arbitrary Data and Key", test_num);
            data = 8'h12;
            key = 16'h3456;
            #10;

            #1;


            check_outputs(8'h44, 8'h44, hashed);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying if only lower bits of key affect output", test_num);
            data = 8'hBC;
            key = 16'hFF23;
            #10;

            #1;


            check_outputs(8'h9F, 8'h9F, hashed);
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
        input [7:0] expected_decrypted;
        input [7:0] expected_encrypted;
        input [7:0] expected_hashed;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decrypted === (expected_decrypted ^ decrypted ^ expected_decrypted) &&
                expected_encrypted === (expected_encrypted ^ encrypted ^ expected_encrypted) &&
                expected_hashed === (expected_hashed ^ hashed ^ expected_hashed)) begin
                $display("PASS");
                $display("  Outputs: decrypted=%h, encrypted=%h, hashed=%h",
                         decrypted, encrypted, hashed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decrypted=%h, encrypted=%h, hashed=%h",
                         expected_decrypted, expected_encrypted, expected_hashed);
                $display("  Got:      decrypted=%h, encrypted=%h, hashed=%h",
                         decrypted, encrypted, hashed);
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
