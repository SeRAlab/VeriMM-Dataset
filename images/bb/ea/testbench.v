`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg [7:0] key;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .key(key),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running testcase %0d: All Zeros", test_num);
        data_in = 8'h00;
        key = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running testcase %0d: Key All Ones (Inversion)", test_num);
        data_in = 8'h5A;
        key = 8'hFF;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running testcase %0d: Key All Zeros (Identity)", test_num);
        data_in = 8'hC3;
        key = 8'h00;
        #1;

        check_outputs(8'hC3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running testcase %0d: Random pattern 1", test_num);
        data_in = 8'h12;
        key = 8'h34;
        #1;

        check_outputs(8'h26);
    end
        endtask

    task testcase005;

        reg [7:0] original_data;
        reg [7:0] encrypted_data;
        reg [7:0] local_key;
    begin
        test_num = 5;
        $display("Running testcase %0d: Reversibility Check", test_num);
        original_data = 8'hDE;
        local_key = 8'hAD;


        data_in = original_data;
        key = local_key;
        #1;
        encrypted_data = data_out;


        data_in = encrypted_data;
        key = local_key;


        #1;



        check_outputs(original_data);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running testcase %0d: High bit test", test_num);
        data_in = 8'h80;
        key = 8'h81;
        #1;

        check_outputs(8'h01);
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
        input [7:0] expected_data_out;
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
