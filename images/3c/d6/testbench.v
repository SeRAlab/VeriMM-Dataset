`timescale 1ns/1ps

module des_round_tb;

    // Testbench signals (combinational circuit)
    reg [55:0] key;
    reg [63:0] plaintext;
    wire [63:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    des_round dut (
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros Plaintext and Key", test_num);


            plaintext = 64'h0000000000000000;
            key = 56'h00000000000000;


            #1;



            check_outputs(64'h00000000E982B3FF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones Plaintext and Key", test_num);
            plaintext = 64'hFFFFFFFFFFFFFFFF;
            key = 56'hFFFFFFFFFFFFFF;

            #1;


            check_outputs(64'hFFFFFFFF017D4C00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Standard Test Vector Pattern", test_num);
            plaintext = 64'h0123456789ABCDEF;
            key = 56'h133457799BBCDF;



            #1;




            check_outputs(64'hF0F0F0F041390CB3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits Pattern A", test_num);
            plaintext = 64'hAAAAAAAAAAAAAAAA;
            key = 56'hAAAAAAAAAAAAAAAA;
            #1;

            check_outputs(64'h55555555EA12C345);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits Pattern 5", test_num);
            plaintext = 64'h5555555555555555;
            key = 56'h55555555555555;
            #1;

            check_outputs(64'hAAAAAAAA12ED3CBA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed High and Low Nibbles", test_num);
            plaintext = 64'hF0F0F0F00F0F0F0F;
            key = 56'hFEDCBA98765432;
            #1;

            check_outputs(64'hA0A0A0A05F5F5F5F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("des_round Testbench");
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
