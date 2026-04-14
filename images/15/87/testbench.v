`timescale 1ns/1ps

module aes_round_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] round_key;
    reg [127:0] state;
    wire [127:0] new_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_round dut (
        .round_key(round_key),
        .state(state),
        .new_state(new_state)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            state = 128'h00000000000000000000000000000000;
            round_key = 128'h00000000000000000000000000000000;
            #1;

            check_outputs(128'h63636363636363636363636363636363);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: NIST-based Vector", test_num);
            state = 128'h00112233445566778899aabbccddeeff;
            round_key = 128'h000102030405060708090a0b0c0d0e0f;
            #1;

            check_outputs(128'heb41f23455c602204a98839a6a2a660b);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Constant Input with FFFF Key", test_num);
            state = 128'h63636363636363636363636363636363;
            round_key = 128'hffffffffffffffffffffffffffffffff;
            #1;

            check_outputs(128'h04040404040404040404040404040404);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Pattern", test_num);
            state = 128'h00ff00ff00ff00ff00ff00ff00ff00ff;
            round_key = 128'h55555555555555555555555555555555;






            #1;







            check_outputs(128'hf49af49af49af49af49af49af49af49a);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit set in state", test_num);
            state = 128'h80000000000000000000000000000000;
            round_key = 128'h00000000000000000000000000000000;





            #1;






            check_outputs(128'he2959595636363636363636363636363);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_round Testbench");
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
        input [127:0] expected_new_state;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_new_state === (expected_new_state ^ new_state ^ expected_new_state)) begin
                $display("PASS");
                $display("  Outputs: new_state=%h",
                         new_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_state=%h",
                         expected_new_state);
                $display("  Got:      new_state=%h",
                         new_state);
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
