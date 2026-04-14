`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] input__payload;
    reg input__valid;
    reg output__ready;
    wire input__ready;
    wire [31:0] output__payload;
    wire output__valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input__payload(input__payload),
        .input__valid(input__valid),
        .output__ready(output__ready),
        .input__ready(input__ready),
        .output__payload(output__payload),
        .output__valid(output__valid)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Basic increment operation (Input 5)", test_num);
            input__payload = 32'h00000005;
            input__valid = 1'b1;
            output__ready = 1'b1;
            #1;

            check_outputs(1'b1, 32'h00000006, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Check overflow handling (Input Max)", test_num);
            input__payload = 32'hFFFFFFFF;
            input__valid = 1'b1;
            output__ready = 1'b1;
            #1;

            check_outputs(1'b1, 32'h00000000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Check valid logic (Input Valid Low)", test_num);
            input__payload = 32'h0000000A;
            input__valid = 1'b0;
            output__ready = 1'b1;

            #1;


            check_outputs(1'b1, 32'h0000000B, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Check backpressure (Output Ready Low)", test_num);
            input__payload = 32'h00000014;
            input__valid = 1'b1;
            output__ready = 1'b0;

            #1;


            check_outputs(1'b0, 32'h00000015, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Incremental value 0", test_num);
            input__payload = 32'h00000000;
            input__valid = 1'b1;
            output__ready = 1'b1;
            #1;

            check_outputs(1'b1, 32'h00000001, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Large value increment", test_num);
            input__payload = 32'h12345678;
            input__valid = 1'b1;
            output__ready = 1'b1;
            #1;

            check_outputs(1'b1, 32'h12345679, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Both Valid and Ready low", test_num);
            input__payload = 32'h000000FF;
            input__valid = 1'b0;
            output__ready = 1'b0;
            #1;

            check_outputs(1'b0, 32'h00000100, 1'b0);
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
        input expected_input__ready;
        input [31:0] expected_output__payload;
        input expected_output__valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_input__ready === (expected_input__ready ^ input__ready ^ expected_input__ready) &&
                expected_output__payload === (expected_output__payload ^ output__payload ^ expected_output__payload) &&
                expected_output__valid === (expected_output__valid ^ output__valid ^ expected_output__valid)) begin
                $display("PASS");
                $display("  Outputs: input__ready=%b, output__payload=%h, output__valid=%b",
                         input__ready, output__payload, output__valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: input__ready=%b, output__payload=%h, output__valid=%b",
                         expected_input__ready, expected_output__payload, expected_output__valid);
                $display("  Got:      input__ready=%b, output__payload=%h, output__valid=%b",
                         input__ready, output__payload, output__valid);
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
