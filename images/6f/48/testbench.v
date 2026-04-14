`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg asi_dma_req_channel;
    reg [127:0] asi_dma_req_data;
    reg asi_dma_req_valid;
    reg aso_dma_req_ready;
    reg clk;
    reg reset;
    wire asi_dma_req_ready;
    wire [127:0] aso_dma_req_data;
    wire aso_dma_req_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .asi_dma_req_channel(asi_dma_req_channel),
        .asi_dma_req_data(asi_dma_req_data),
        .asi_dma_req_valid(asi_dma_req_valid),
        .aso_dma_req_ready(aso_dma_req_ready),
        .clk(clk),
        .reset(reset),
        .asi_dma_req_ready(asi_dma_req_ready),
        .aso_dma_req_data(aso_dma_req_data),
        .aso_dma_req_valid(aso_dma_req_valid)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Data Transfer", test_num);


            reset = 1;
            asi_dma_req_data = 0;
            asi_dma_req_valid = 0;
            aso_dma_req_ready = 0;
            asi_dma_req_channel = 0;
            @(posedge clk);
            #1 reset = 0;


            asi_dma_req_data = 128'hDEADBEEF_CAFEBABE_01234567_89ABCDEF;
            asi_dma_req_valid = 1'b1;
            aso_dma_req_ready = 1'b1;
            asi_dma_req_channel = 1'b0;

            @(posedge clk);
            #1;

            check_outputs(1'b1, 128'hDEADBEEF_CAFEBABE_01234567_89ABCDEF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Backpressure Handling", test_num);


            reset = 1;
            @(posedge clk);
            #1 reset = 0;


            asi_dma_req_data = 128'h11112222333344445555666677778888;
            asi_dma_req_valid = 1'b1;
            aso_dma_req_ready = 1'b0;
            asi_dma_req_channel = 1'b1;

            @(posedge clk);
            #1;

            check_outputs(1'b0, 128'h11112222333344445555666677778888, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Source Idle", test_num);


            reset = 1;
            @(posedge clk);
            #1 reset = 0;


            asi_dma_req_data = 128'hFFFFFFFF_00000000_FFFFFFFF_00000000;
            asi_dma_req_valid = 1'b0;
            aso_dma_req_ready = 1'b1;
            asi_dma_req_channel = 1'b0;

            @(posedge clk);
            #1;

            check_outputs(1'b1, 128'hFFFFFFFF_00000000_FFFFFFFF_00000000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Channel Removal Check", test_num);


            reset = 1;
            @(posedge clk);
            #1 reset = 0;


            asi_dma_req_data = 128'hAAAA5555_BBBB6666_CCCC7777_DDDD8888;
            asi_dma_req_valid = 1'b1;
            aso_dma_req_ready = 1'b1;
            asi_dma_req_channel = 1'b1;

            @(posedge clk);

            #1;


            check_outputs(1'b1, 128'hAAAA5555_BBBB6666_CCCC7777_DDDD8888, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Zero Data Pattern", test_num);


            reset = 1;
            @(posedge clk);
            #1 reset = 0;


            asi_dma_req_data = 128'h0;
            asi_dma_req_valid = 1'b1;
            aso_dma_req_ready = 1'b1;
            asi_dma_req_channel = 1'b1;

            @(posedge clk);
            #1;

            check_outputs(1'b1, 128'h0, 1'b1);
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
        input expected_asi_dma_req_ready;
        input [127:0] expected_aso_dma_req_data;
        input expected_aso_dma_req_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_asi_dma_req_ready === (expected_asi_dma_req_ready ^ asi_dma_req_ready ^ expected_asi_dma_req_ready) &&
                expected_aso_dma_req_data === (expected_aso_dma_req_data ^ aso_dma_req_data ^ expected_aso_dma_req_data) &&
                expected_aso_dma_req_valid === (expected_aso_dma_req_valid ^ aso_dma_req_valid ^ expected_aso_dma_req_valid)) begin
                $display("PASS");
                $display("  Outputs: asi_dma_req_ready=%b, aso_dma_req_data=%h, aso_dma_req_valid=%b",
                         asi_dma_req_ready, aso_dma_req_data, aso_dma_req_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: asi_dma_req_ready=%b, aso_dma_req_data=%h, aso_dma_req_valid=%b",
                         expected_asi_dma_req_ready, expected_aso_dma_req_data, expected_aso_dma_req_valid);
                $display("  Got:      asi_dma_req_ready=%b, aso_dma_req_data=%h, aso_dma_req_valid=%b",
                         asi_dma_req_ready, aso_dma_req_data, aso_dma_req_valid);
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
