`timescale 1ns/1ps

module simple_des_round_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] key;
    reg [63:0] plaintext;
    wire [63:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_des_round dut (
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros - Checking basic propagation", test_num);
        plaintext = 64'h0000000000000000;
        key = 64'h0000000000000000;



        #1;




        check_outputs(64'h0000000000000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Key Influence - Zero plaintext, non-zero key", test_num);
        plaintext = 64'h0000000000000000;
        key = 64'hFFFFFFFFFFFFFFFF;


        #1;



        check_outputs(64'h00000000FFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Data Influence - Non-zero plaintext, zero key", test_num);
        plaintext = 64'hFEDCBA9876543210;
        key = 64'h0000000000000000;

        #1;


        check_outputs(64'h76543210FEDCBA98);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bits (0x55/0xAA)", test_num);
        plaintext = 64'h5555555555555555;
        key = 64'hAAAAAAAAAAAAAAAA;

        #1;


        check_outputs(64'h55555555FFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones", test_num);
        plaintext = 64'hFFFFFFFFFFFFFFFF;
        key = 64'hFFFFFFFFFFFFFFFF;

        #1;


        check_outputs(64'hFFFFFFFF00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mixed Hex Pattern", test_num);
        plaintext = 64'h123456789ABCDEF0;
        key = 64'h0F0F0F0F0F0F0F0F;
        #1;

        check_outputs(64'h9ABCDEF01D3B597F);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_des_round Testbench");
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
