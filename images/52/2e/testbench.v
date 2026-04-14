`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [9:0] cmd_payload_function_id;
    reg [31:0] cmd_payload_inputs_0;
    reg [31:0] cmd_payload_inputs_1;
    reg cmd_valid;
    reg reset;
    reg rsp_ready;
    wire cmd_ready;
    wire [31:0] rsp_payload_outputs_0;
    wire rsp_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .cmd_payload_function_id(cmd_payload_function_id),
        .cmd_payload_inputs_0(cmd_payload_inputs_0),
        .cmd_payload_inputs_1(cmd_payload_inputs_1),
        .cmd_valid(cmd_valid),
        .reset(reset),
        .rsp_ready(rsp_ready),
        .cmd_ready(cmd_ready),
        .rsp_payload_outputs_0(rsp_payload_outputs_0),
        .rsp_valid(rsp_valid)
    );
    task testcase001;

        begin
            $display("Testcase 001: Reset and Initialization");
            reset = 1;
            cmd_valid = 0;
            rsp_ready = 0;
            cmd_payload_function_id = 0;
            cmd_payload_inputs_0 = 0;
            cmd_payload_inputs_1 = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Function ID 0 (Select Input 0)");
            cmd_payload_function_id = 10'd0;
            cmd_payload_inputs_0 = 32'hDEADBEEF;
            cmd_payload_inputs_1 = 32'h12345678;
            cmd_valid = 1;
            rsp_ready = 1;
            @(posedge clk);

            #1;


            check_outputs(1, 32'hDEADBEEF, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Function ID 1 (Select Input 1)");
            cmd_payload_function_id = 10'd1;
            cmd_payload_inputs_0 = 32'hAAAA_AAAA;
            cmd_payload_inputs_1 = 32'h5555_5555;
            cmd_valid = 1;
            rsp_ready = 1;
            @(posedge clk);

            #1;


            check_outputs(1, 32'h5555_5555, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Backpressure (Ready Low)");
            cmd_payload_function_id = 10'd0;
            cmd_payload_inputs_0 = 32'hCAFEFEED;
            cmd_valid = 1;
            rsp_ready = 0;
            @(posedge clk);

            #1;


            check_outputs(0, 32'hCAFEFEED, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Idle State (Valid Low)");
            cmd_payload_function_id = 10'd0;
            cmd_payload_inputs_0 = 32'h1111_1111;
            cmd_valid = 0;
            rsp_ready = 1;
            @(posedge clk);


            #1;



            check_outputs(1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Large Values / Alternative ID");
            cmd_payload_function_id = 10'h3FF;
            cmd_payload_inputs_0 = 32'hFFFF_FFFF;
            cmd_payload_inputs_1 = 32'h8000_0000;
            cmd_valid = 1;
            rsp_ready = 1;
            @(posedge clk);


            #1;



            check_outputs(1, 32'h8000_0000, 1);
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
        input expected_cmd_ready;
        input [31:0] expected_rsp_payload_outputs_0;
        input expected_rsp_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cmd_ready === (expected_cmd_ready ^ cmd_ready ^ expected_cmd_ready) &&
                expected_rsp_payload_outputs_0 === (expected_rsp_payload_outputs_0 ^ rsp_payload_outputs_0 ^ expected_rsp_payload_outputs_0) &&
                expected_rsp_valid === (expected_rsp_valid ^ rsp_valid ^ expected_rsp_valid)) begin
                $display("PASS");
                $display("  Outputs: cmd_ready=%b, rsp_payload_outputs_0=%h, rsp_valid=%b",
                         cmd_ready, rsp_payload_outputs_0, rsp_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cmd_ready=%b, rsp_payload_outputs_0=%h, rsp_valid=%b",
                         expected_cmd_ready, expected_rsp_payload_outputs_0, expected_rsp_valid);
                $display("  Got:      cmd_ready=%b, rsp_payload_outputs_0=%h, rsp_valid=%b",
                         cmd_ready, rsp_payload_outputs_0, rsp_valid);
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
