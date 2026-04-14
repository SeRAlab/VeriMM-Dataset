`timescale 1ns/1ps

module des_single_round_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] key;
    reg [63:0] plaintext;
    wire [63:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    des_single_round dut (
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            plaintext = 64'h0000_0000_0000_0000;
            key       = 64'h0000_0000_0000_0000;


            #1;



            check_outputs(64'hL0R0_Placeholder_Value);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            plaintext = 64'hFFFF_FFFF_FFFF_FFFF;
            key       = 64'hFFFF_FFFF_FFFF_FFFF;
            #1;

            check_outputs(64'hL0R0_Placeholder_Value);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard Pattern A", test_num);
            plaintext = 64'h5555_5555_5555_5555;
            key       = 64'hAAAA_AAAA_AAAA_AAAA;
            #1;

            check_outputs(64'hL0R0_Placeholder_Value);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard Pattern B", test_num);
            plaintext = 64'hAAAA_AAAA_AAAA_AAAA;
            key       = 64'h5555_5555_5555_5555;
            #1;

            check_outputs(64'hL0R0_Placeholder_Value);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Incremental Hex Pattern", test_num);
            plaintext = 64'h0123_4567_89AB_CDEF;
            key       = 64'hFEDC_BA98_7654_3210;
            #1;

            check_outputs(64'hL0R0_Placeholder_Value);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key with Single Bit Set", test_num);
            plaintext = 64'h0000_0000_0000_0000;
            key       = 64'h8000_0000_0000_0000;
            #1;

            check_outputs(64'hL0R0_Placeholder_Value);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Plaintext with Single Bit Set", test_num);
            plaintext = 64'h0000_0000_0000_0001;
            key       = 64'h0000_0000_0000_0000;
            #1;

            check_outputs(64'hL0R0_Placeholder_Value);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("des_single_round Testbench");
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
        input [63:0] expected_ciphertext;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%h",
                         ciphertext);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%h",
                         expected_ciphertext);
                $display("  Got:      ciphertext=%h",
                         ciphertext);
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
