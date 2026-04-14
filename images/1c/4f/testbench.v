`timescale 1ns/1ps

module simple_des_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] key;
    reg [63:0] plaintext;
    wire [63:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_des dut (
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All zeros input", test_num);
            plaintext = 64'h0000000000000000;
            key       = 64'h0000000000000000;


            #1;



            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All ones input", test_num);
            plaintext = 64'hFFFFFFFFFFFFFFFF;
            key       = 64'hFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating bits (5555)", test_num);
            plaintext = 64'h5555555555555555;
            key       = 64'hAAAAAAAAAAAAAAAA;
            #1;

            check_outputs(64'h5555555555555555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating bits (AAAA)", test_num);
            plaintext = 64'hAAAAAAAAAAAAAAAA;
            key       = 64'h5555555555555555;
            #1;

            check_outputs(64'hAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Walking one in plaintext", test_num);
            plaintext = 64'h8000000000000000;
            key       = 64'h0000000000000000;
            #1;

            check_outputs(64'h8000000000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Walking one in key", test_num);
            plaintext = 64'h0000000000000000;
            key       = 64'h0000000000000001;
            #1;

            check_outputs(64'h0000000000000001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Random mixed pattern 1", test_num);
            plaintext = 64'h123456789ABCDEF0;
            key       = 64'hFEDCBA9876543210;
            #1;

            check_outputs(64'h123456789ABCDEF0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Random mixed pattern 2", test_num);
            plaintext = 64'hA5A5A5A5A5A5A5A5;
            key       = 64'h5A5A5A5A5A5A5A5A;
            #1;

            check_outputs(64'hA5A5A5A5A5A5A5A5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_des Testbench");
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
