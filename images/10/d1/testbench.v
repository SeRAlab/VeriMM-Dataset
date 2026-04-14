`timescale 1ns/1ps

module aes_key_gen_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] key_in;
    wire [127:0] round_key;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_key_gen dut (
        .key_in(key_in),
        .round_key(round_key)
    );
    task testcase001;

        begin
            $display("Test Case 001: FIPS-197 Standard Example");
            test_num = test_num + 1;

            key_in = 128'h000102030405060708090a0b0c0d0e0f;

            #1;


            check_outputs(128'hd6aa74fdd2af72fadaa678f1d6ab76fe);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: All Zeros Key");
            test_num = test_num + 1;
            key_in = 128'h00000000000000000000000000000000;


            #1;



            check_outputs(128'h62636363626363636263636362636363);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: NIST 800-38A Example Key");
            test_num = test_num + 1;

            key_in = 128'h2b7e151628aed2a6abf7158809cf4f3c;

            #1;


            check_outputs(128'ha0fafe1788542cb123a339392a6c7605);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: All Ones Key");
            test_num = test_num + 1;
            key_in = 128'hffffffffffffffffffffffffffffffff;





            #1;






            check_outputs(128'he8e9e9e917161616e8e9e9e917161616);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_key_gen Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
