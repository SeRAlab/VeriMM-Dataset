`timescale 1ns/1ps

module DES_round_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] data_in;
    reg [55:0] key;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DES_round dut (
        .data_in(data_in),
        .key(key),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        data_in = 64'h0000000000000000;
        key = 56'h00000000000000;
        $display("Testcase %0d: All Zeros", test_num);
        #1;

        check_outputs(64'h000000004da4014c);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        data_in = 64'h0123456789ABCDEF;
        key = 56'h0E329232EA6D0D;
        $display("Testcase %0d: Standard Vector (Intermediate Round 1)", test_num);
        #1;

        check_outputs(64'hf0f0f0f0ef4a6033);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        data_in = 64'hFFFFFFFFFFFFFFFF;
        key = 56'hFFFFFFFFFFFFFF;
        $display("Testcase %0d: All Ones", test_num);
        #1;

        check_outputs(64'hFFFFFFFFb25bfeb3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        data_in = 64'h0000000000000000;
        key = 56'hFFFFFFFFFFFFFF;
        $display("Testcase %0d: Zero Data with All Ones Key", test_num);
        #1;

        check_outputs(64'h000000009411002c);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DES_round Testbench");
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
        input [63:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
