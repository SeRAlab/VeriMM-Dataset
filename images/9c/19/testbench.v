`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] ack;
    reg clk;
    reg [3:0] req;
    reg rst;
    wire [3:0] mem_ack;
    wire [3:0] mem_req;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ack(ack),
        .clk(clk),
        .req(req),
        .rst(rst),
        .mem_ack(mem_ack),
        .mem_req(mem_req)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req = 4'b0000;
            ack = 4'b0000;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Request (Req 0)", test_num);
            reset_dut();
            req = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000, 4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Check (Req 0 and 2)", test_num);
            reset_dut();
            req = 4'b0101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000, 4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Handshake Request 1", test_num);
            reset_dut();
            req = 4'b0010;
            @(posedge clk);
            #1;
            ack = 4'b0010;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0010, 4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Requestors Active", test_num);
            reset_dut();
            req = 4'b1111;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0000, 4'b0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle State", test_num);
            reset_dut();
            req = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000, 4'b0000);
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
        input [3:0] expected_mem_ack;
        input [3:0] expected_mem_req;
        begin
            if (expected_mem_ack === (expected_mem_ack ^ mem_ack ^ expected_mem_ack) &&
                expected_mem_req === (expected_mem_req ^ mem_req ^ expected_mem_req)) begin
                $display("PASS");
                $display("  Outputs: mem_ack=%h, mem_req=%h",
                         mem_ack, mem_req);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_ack=%h, mem_req=%h",
                         expected_mem_ack, expected_mem_req);
                $display("  Got:      mem_ack=%h, mem_req=%h",
                         mem_ack, mem_req);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,ack, clk, req, rst, mem_ack, mem_req);
    end

endmodule
