`timescale 1ns/1ps

module aes_round_function_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] round_key;
    reg [127:0] state;
    wire [127:0] encrypted_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_round_function dut (
        .round_key(round_key),
        .state(state),
        .encrypted_state(encrypted_state)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: FIPS 197 Standard Vector - Round 1", test_num);

            state = 128'h193de3bea99a932b1a888d2ad9f84808;

            round_key = 128'ha0fafe1788542cb123a339392a6c7605;

            #1;


            check_outputs(128'ha49c7ff2689f352b6b5be187026a5049);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: FIPS 197 Standard Vector - Round 2", test_num);

            state = 128'ha49c7ff2689f352b6b5be187026a5049;

            round_key = 128'hf2c295f27a96b9435935807a7359f67f;
            #1;

            check_outputs(128'haafb5f0361dde3ef82d24ad26832469a);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Input and Key", test_num);
            state = 128'h00000000000000000000000000000000;
            round_key = 128'h00000000000000000000000000000000;

            #1;


            check_outputs(128'h63636363636363636363636363636363);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (FF) Input with Zero Key", test_num);
            state = 128'hffffffffffffffffffffffffffffffff;
            round_key = 128'h00000000000000000000000000000000;

            #1;


            check_outputs(128'h16161616161616161616161616161616);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (FF) Input with All Ones (FF) Key", test_num);
            state = 128'hffffffffffffffffffffffffffffffff;
            round_key = 128'hffffffffffffffffffffffffffffffff;

            #1;


            check_outputs(128'he9e9e9e9e9e9e9e9e9e9e9e9e9e9e9e9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_round_function Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [127:0] expected_encrypted_state;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encrypted_state === (expected_encrypted_state ^ encrypted_state ^ expected_encrypted_state)) begin
                $display("PASS");
                $display("  Outputs: encrypted_state=%h",
                         encrypted_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encrypted_state=%h",
                         expected_encrypted_state);
                $display("  Got:      encrypted_state=%h",
                         encrypted_state);
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
