`timescale 1ns/1ps

module aes_key_expansion_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] key;
    wire [127:0] round_key;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_key_expansion dut (
        .key(key),
        .round_key(round_key)
    );
    task testcase001;

        begin
            $display("Testcase 001: All Zeros");
            test_num = test_num + 1;
            key = 256'h0;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All Ones");
            test_num = test_num + 1;
            key = {256{1'b1}};
            #1;

            check_outputs({128{1'b1}});
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Distinct High and Low Half");
            test_num = test_num + 1;

            key = {128'hAAAA_AAAA_BBBB_BBBB_CCCC_CCCC_DDDD_DDDD, 128'h1111_1111_2222_2222_3333_3333_4444_4444};
            #1;

            check_outputs(128'hAAAA_AAAA_BBBB_BBBB_CCCC_CCCC_DDDD_DDDD);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Standard AES-256 Example Key");
            test_num = test_num + 1;

            key = 256'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4;

            #1;


            check_outputs(128'h603deb1015ca71be2b73aef0857d7781);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Hex Pattern Key");
            test_num = test_num + 1;
            key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            #1;

            check_outputs(128'h000102030405060708090a0b0c0d0e0f);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Alternating Bit Pattern");
            test_num = test_num + 1;
            key = 256'h55555555555555555555555555555555AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            #1;

            check_outputs(128'h55555555555555555555555555555555);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Checkerboard Pattern");
            test_num = test_num + 1;
            key = 256'hF0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F;
            #1;

            check_outputs(128'hF0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_key_expansion Testbench");
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
        input [127:0] expected_round_key;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_round_key === (expected_round_key ^ round_key ^ expected_round_key)) begin
                $display("PASS");
                $display("  Outputs: round_key=%h",
                         round_key);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: round_key=%h",
                         expected_round_key);
                $display("  Got:      round_key=%h",
                         round_key);
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
