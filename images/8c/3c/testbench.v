`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] state_data_in;
    wire [127:0] state_data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .state_data_in(state_data_in),
        .state_data_out(state_data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            state_data_in = 128'h0;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Incremental Byte Sequence", test_num);
            state_data_in = 128'h000102030405060708090a0b0c0d0e0f;
            #1;

            check_outputs(128'h00050a0f04090e03080d02070c01060b);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: AES Standard Example (FIPS 197)", test_num);
            state_data_in = 128'h637c777bf26b6fc53001672bfed7ab76;
            #1;

            check_outputs(128'h636b6776f201ab7b30d777c5fe7c6f2b);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All FFs", test_num);
            state_data_in = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Specific Pattern Verification", test_num);
            state_data_in = 128'h00112233445566778899aabbccddeeff;
            #1;

            check_outputs(128'h0055aaff4499ee3388dd2277cc1166bb);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Uniform Row Verification", test_num);
            state_data_in = 128'hAABBCCDDAABBCCDDAABBCCDDAABBCCDD;
            #1;

            check_outputs(128'hAABBCCDDAABBCCDDAABBCCDDAABBCCDD);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Byte Propagation (Row 1 Shift)", test_num);
            state_data_in = 128'h00EE0000000000000000000000000000;

            #1;


            check_outputs(128'h00000000000000000000000000EE0000);
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
        input [127:0] expected_state_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_state_data_out === (expected_state_data_out ^ state_data_out ^ expected_state_data_out)) begin
                $display("PASS");
                $display("  Outputs: state_data_out=%h",
                         state_data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state_data_out=%h",
                         expected_state_data_out);
                $display("  Got:      state_data_out=%h",
                         state_data_out);
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
