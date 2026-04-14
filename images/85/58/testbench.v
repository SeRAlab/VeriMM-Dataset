`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg error_inject;
    reg [15:0] key;
    wire [7:0] data_out;
    wire error_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .error_inject(error_inject),
        .key(key),
        .data_out(data_out),
        .error_detected(error_detected)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Normal Encryption/Decryption - Data 8'hA5, Key 16'h1234", test_num);
        data_in = 8'hA5;
        key = 16'h1234;
        error_inject = 1'b0;

        #1;


        check_outputs(8'hA5, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Error Injection Test - Data 8'hA5, Key 16'h1234", test_num);
        data_in = 8'hA5;
        key = 16'h1234;
        error_inject = 1'b1;
        #1;


        if (error_detected === 1'b1) begin
            $display("PASS: Error correctly detected");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Error NOT detected despite error_inject=1");
            fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Boundary Test - All Zeros", test_num);
        data_in = 8'h00;
        key = 16'h0000;
        error_inject = 1'b0;
        #1;

        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Boundary Test - All Ones", test_num);
        data_in = 8'hFF;
        key = 16'hFFFF;
        error_inject = 1'b0;
        #1;

        check_outputs(8'hFF, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Alternative Key and Data Pattern", test_num);
        data_in = 8'h5A;
        key = 16'hAA55;
        error_inject = 1'b0;
        #1;

        check_outputs(8'h5A, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Error Injection with different key", test_num);
        data_in = 8'h12;
        key = 16'h9876;
        error_inject = 1'b1;
        #1;
        if (error_detected === 1'b1) begin
            $display("PASS: Error correctly detected");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Error NOT detected");
            fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Prime-like Data Input", test_num);
        data_in = 8'hD3;
        key = 16'hC0DE;
        error_inject = 1'b0;
        #1;

        check_outputs(8'hD3, 1'b0);
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
        input [7:0] expected_data_out;
        input expected_error_detected;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error_detected === (expected_error_detected ^ error_detected ^ expected_error_detected)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, error_detected=%b",
                         data_out, error_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, error_detected=%b",
                         expected_data_out, expected_error_detected);
                $display("  Got:      data_out=%h, error_detected=%b",
                         data_out, error_detected);
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
