`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] input_val;
    wire [31:0] address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_val(input_val),
        .address(address)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        input_val = 32'd1024;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        input_val = 32'd1027;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        input_val = 32'd1028;
        #1;

        check_outputs(32'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        input_val = 32'd2051;
        #1;

        check_outputs(32'h400);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        input_val = 32'd0;
        #1;

        check_outputs(32'hFFFFFC00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        input_val = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hFFFFFBFC);
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
        input [31:0] expected_address;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_address === (expected_address ^ address ^ expected_address)) begin
                $display("PASS");
                $display("  Outputs: address=%h",
                         address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address=%h",
                         expected_address);
                $display("  Got:      address=%h",
                         address);
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
