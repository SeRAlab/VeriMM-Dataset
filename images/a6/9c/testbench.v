`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [2:0] io_bus_cmd_payload_function_id;
    reg [31:0] io_bus_cmd_payload_inputs_0;
    reg [31:0] io_bus_cmd_payload_inputs_1;
    reg io_bus_cmd_valid;
    reg io_bus_rsp_ready;
    wire io_bus_cmd_ready;
    wire [31:0] io_bus_rsp_payload_outputs_0;
    wire io_bus_rsp_payload_response_ok;
    wire io_bus_rsp_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .io_bus_cmd_payload_function_id(io_bus_cmd_payload_function_id),
        .io_bus_cmd_payload_inputs_0(io_bus_cmd_payload_inputs_0),
        .io_bus_cmd_payload_inputs_1(io_bus_cmd_payload_inputs_1),
        .io_bus_cmd_valid(io_bus_cmd_valid),
        .io_bus_rsp_ready(io_bus_rsp_ready),
        .io_bus_cmd_ready(io_bus_cmd_ready),
        .io_bus_rsp_payload_outputs_0(io_bus_rsp_payload_outputs_0),
        .io_bus_rsp_payload_response_ok(io_bus_rsp_payload_response_ok),
        .io_bus_rsp_valid(io_bus_rsp_valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Function ID 0 (Select Input 0)", test_num);

            io_bus_cmd_valid = 1;
            io_bus_rsp_ready = 1;
            io_bus_cmd_payload_function_id = 3'b000;
            io_bus_cmd_payload_inputs_0 = 32'hAAAA_AAAA;
            io_bus_cmd_payload_inputs_1 = 32'h5555_5555;


            #1;



            check_outputs(1'b1, 32'hAAAA_AAAA, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Function ID 1 (Select Input 1)", test_num);

            io_bus_cmd_valid = 1;
            io_bus_rsp_ready = 1;
            io_bus_cmd_payload_function_id = 3'b001;
            io_bus_cmd_payload_inputs_0 = 32'h1234_5678;
            io_bus_cmd_payload_inputs_1 = 32'h8765_4321;


            #1;



            check_outputs(1'b1, 32'h8765_4321, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Function ID 2 (LSB 0 selects Input 0)", test_num);

            io_bus_cmd_valid = 1;
            io_bus_rsp_ready = 1;
            io_bus_cmd_payload_function_id = 3'b010;
            io_bus_cmd_payload_inputs_0 = 32'hDEAD_BEEF;
            io_bus_cmd_payload_inputs_1 = 32'hCAFE_BABE;


            #1;



            check_outputs(1'b1, 32'hDEAD_BEEF, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Function ID 7 (LSB 1 selects Input 1)", test_num);

            io_bus_cmd_valid = 1;
            io_bus_rsp_ready = 1;
            io_bus_cmd_payload_function_id = 3'b111;
            io_bus_cmd_payload_inputs_0 = 32'h0000_FFFF;
            io_bus_cmd_payload_inputs_1 = 32'hFFFF_0000;


            #1;



            check_outputs(1'b1, 32'hFFFF_0000, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Invalid Command (valid=0)", test_num);

            io_bus_cmd_valid = 0;
            io_bus_rsp_ready = 1;
            io_bus_cmd_payload_function_id = 3'b001;
            io_bus_cmd_payload_inputs_0 = 32'h1111_1111;
            io_bus_cmd_payload_inputs_1 = 32'h2222_2222;


            #1;



            check_outputs(1'b1, 32'h2222_2222, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Backpressure (rsp_ready=0)", test_num);

            io_bus_cmd_valid = 1;
            io_bus_rsp_ready = 0;
            io_bus_cmd_payload_function_id = 3'b000;
            io_bus_cmd_payload_inputs_0 = 32'h9999_9999;
            io_bus_cmd_payload_inputs_1 = 32'h8888_8888;


            #1;



            check_outputs(1'b0, 32'h9999_9999, 1'b1, 1'b1);
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
        input expected_io_bus_cmd_ready;
        input [31:0] expected_io_bus_rsp_payload_outputs_0;
        input expected_io_bus_rsp_payload_response_ok;
        input expected_io_bus_rsp_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_bus_cmd_ready === (expected_io_bus_cmd_ready ^ io_bus_cmd_ready ^ expected_io_bus_cmd_ready) &&
                expected_io_bus_rsp_payload_outputs_0 === (expected_io_bus_rsp_payload_outputs_0 ^ io_bus_rsp_payload_outputs_0 ^ expected_io_bus_rsp_payload_outputs_0) &&
                expected_io_bus_rsp_payload_response_ok === (expected_io_bus_rsp_payload_response_ok ^ io_bus_rsp_payload_response_ok ^ expected_io_bus_rsp_payload_response_ok) &&
                expected_io_bus_rsp_valid === (expected_io_bus_rsp_valid ^ io_bus_rsp_valid ^ expected_io_bus_rsp_valid)) begin
                $display("PASS");
                $display("  Outputs: io_bus_cmd_ready=%b, io_bus_rsp_payload_outputs_0=%h, io_bus_rsp_payload_response_ok=%b, io_bus_rsp_valid=%b",
                         io_bus_cmd_ready, io_bus_rsp_payload_outputs_0, io_bus_rsp_payload_response_ok, io_bus_rsp_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_bus_cmd_ready=%b, io_bus_rsp_payload_outputs_0=%h, io_bus_rsp_payload_response_ok=%b, io_bus_rsp_valid=%b",
                         expected_io_bus_cmd_ready, expected_io_bus_rsp_payload_outputs_0, expected_io_bus_rsp_payload_response_ok, expected_io_bus_rsp_valid);
                $display("  Got:      io_bus_cmd_ready=%b, io_bus_rsp_payload_outputs_0=%h, io_bus_rsp_payload_response_ok=%b, io_bus_rsp_valid=%b",
                         io_bus_cmd_ready, io_bus_rsp_payload_outputs_0, io_bus_rsp_payload_response_ok, io_bus_rsp_valid);
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
