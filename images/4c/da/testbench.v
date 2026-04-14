`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] addroundkey_data_i;
    reg [3:0] addroundkey_data_reg;
    reg [3:0] addroundkey_round;
    reg addroundkey_start_i;
    reg [3:0] key_i;
    reg [3:0] keysched_new_key_o;
    reg keysched_ready_o;
    reg [3:0] round;
    wire [3:0] keysched_last_key_i;
    wire [3:0] keysched_round_i;
    wire keysched_start_i;
    wire [3:0] next_addroundkey_data_reg;
    wire next_addroundkey_ready_o;
    wire [3:0] next_addroundkey_round;
    wire [3:0] round_data_var;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addroundkey_data_i(addroundkey_data_i),
        .addroundkey_data_reg(addroundkey_data_reg),
        .addroundkey_round(addroundkey_round),
        .addroundkey_start_i(addroundkey_start_i),
        .key_i(key_i),
        .keysched_new_key_o(keysched_new_key_o),
        .keysched_ready_o(keysched_ready_o),
        .round(round),
        .keysched_last_key_i(keysched_last_key_i),
        .keysched_round_i(keysched_round_i),
        .keysched_start_i(keysched_start_i),
        .next_addroundkey_data_reg(next_addroundkey_data_reg),
        .next_addroundkey_ready_o(next_addroundkey_ready_o),
        .next_addroundkey_round(next_addroundkey_round),
        .round_data_var(round_data_var)
    );
    task testcase001;

        begin
            test_num = 1;
            addroundkey_data_i = 4'h0;
            addroundkey_data_reg = 4'h0;
            addroundkey_round = 4'h0;
            addroundkey_start_i = 1'b0;
            key_i = 4'h0;
            keysched_new_key_o = 4'h0;
            keysched_ready_o = 1'b0;
            round = 4'h0;
            #1;

            check_outputs(4'h0, 4'h0, 1'b0, 4'h0, 1'b0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            addroundkey_data_i = 4'hA;
            keysched_new_key_o = 4'h5;
            keysched_ready_o = 1'b1;
            #1;

            check_outputs(4'h0, 4'h0, 1'b0, 4'hF, 1'b1, 4'h0, 4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            key_i = 4'hE;
            round = 4'h9;
            addroundkey_start_i = 1'b1;
            #1;

            check_outputs(4'hE, 4'h9, 1'b1, 4'hF, 1'b1, 4'h9, 4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            addroundkey_data_i = 4'h1;
            keysched_new_key_o = 4'h1;
            addroundkey_data_reg = 4'hB;
            addroundkey_round = 4'h2;
            keysched_ready_o = 1'b0;
            round = 4'h5;
            #1;

            check_outputs(4'hE, 4'h5, 1'b1, 4'hB, 1'b0, 4'h2, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            addroundkey_data_i = 4'h3;
            keysched_new_key_o = 4'hC;
            addroundkey_data_reg = 4'h0;
            addroundkey_round = 4'h1;
            keysched_ready_o = 1'b1;
            round = 4'h7;
            #1;

            check_outputs(4'hE, 4'h7, 1'b1, 4'hF, 1'b1, 4'h7, 4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            addroundkey_data_i = 4'hF;
            keysched_new_key_o = 4'hF;
            addroundkey_data_reg = 4'h5;
            addroundkey_round = 4'hA;
            keysched_ready_o = 1'b0;
            round = 4'hF;
            key_i = 4'h1;
            addroundkey_start_i = 1'b0;
            #1;

            check_outputs(4'h1, 4'hF, 1'b0, 4'h5, 1'b0, 4'hA, 4'h0);
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
        input [3:0] expected_keysched_last_key_i;
        input [3:0] expected_keysched_round_i;
        input expected_keysched_start_i;
        input [3:0] expected_next_addroundkey_data_reg;
        input expected_next_addroundkey_ready_o;
        input [3:0] expected_next_addroundkey_round;
        input [3:0] expected_round_data_var;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_keysched_last_key_i === (expected_keysched_last_key_i ^ keysched_last_key_i ^ expected_keysched_last_key_i) &&
                expected_keysched_round_i === (expected_keysched_round_i ^ keysched_round_i ^ expected_keysched_round_i) &&
                expected_keysched_start_i === (expected_keysched_start_i ^ keysched_start_i ^ expected_keysched_start_i) &&
                expected_next_addroundkey_data_reg === (expected_next_addroundkey_data_reg ^ next_addroundkey_data_reg ^ expected_next_addroundkey_data_reg) &&
                expected_next_addroundkey_ready_o === (expected_next_addroundkey_ready_o ^ next_addroundkey_ready_o ^ expected_next_addroundkey_ready_o) &&
                expected_next_addroundkey_round === (expected_next_addroundkey_round ^ next_addroundkey_round ^ expected_next_addroundkey_round) &&
                expected_round_data_var === (expected_round_data_var ^ round_data_var ^ expected_round_data_var)) begin
                $display("PASS");
                $display("  Outputs: keysched_last_key_i=%h, keysched_round_i=%h, keysched_start_i=%b, next_addroundkey_data_reg=%h, next_addroundkey_ready_o=%b, next_addroundkey_round=%h, round_data_var=%h",
                         keysched_last_key_i, keysched_round_i, keysched_start_i, next_addroundkey_data_reg, next_addroundkey_ready_o, next_addroundkey_round, round_data_var);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: keysched_last_key_i=%h, keysched_round_i=%h, keysched_start_i=%b, next_addroundkey_data_reg=%h, next_addroundkey_ready_o=%b, next_addroundkey_round=%h, round_data_var=%h",
                         expected_keysched_last_key_i, expected_keysched_round_i, expected_keysched_start_i, expected_next_addroundkey_data_reg, expected_next_addroundkey_ready_o, expected_next_addroundkey_round, expected_round_data_var);
                $display("  Got:      keysched_last_key_i=%h, keysched_round_i=%h, keysched_start_i=%b, next_addroundkey_data_reg=%h, next_addroundkey_ready_o=%b, next_addroundkey_round=%h, round_data_var=%h",
                         keysched_last_key_i, keysched_round_i, keysched_start_i, next_addroundkey_data_reg, next_addroundkey_ready_o, next_addroundkey_round, round_data_var);
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
