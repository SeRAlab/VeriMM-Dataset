`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg data_in_ready;
    reg [31:0] ic_addr;
    reg ic_rq;
    reg reset;
    wire [31:0] data_address;
    wire data_rd;
    wire [31:0] ic_data_out;
    wire ic_data_out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .data_in_ready(data_in_ready),
        .ic_addr(ic_addr),
        .ic_rq(ic_rq),
        .reset(reset),
        .data_address(data_address),
        .data_rd(data_rd),
        .ic_data_out(ic_data_out),
        .ic_data_out_valid(ic_data_out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ic_rq = 0;
            ic_addr = 0;
            data_in = 0;
            data_in_ready = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic single instruction read", test_num);
            reset_dut();


            ic_rq = 1;
            ic_addr = 32'h12345678;


            @(posedge clk);
            #1;

            data_in = 32'hDEADBEEF;
            data_in_ready = 1;


            @(posedge clk);
            #1;





            #1;






            check_outputs(32'h12345678, data_rd, 32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Different address and data", test_num);
            reset_dut();

            ic_rq = 1;
            ic_addr = 32'hAAAA_BBBB;

            @(posedge clk);
            #1;
            data_in = 32'h5555_6666;
            data_in_ready = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hAAAA_BBBB, data_rd, 32'h5555_6666, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Memory bus latency", test_num);
            reset_dut();

            ic_rq = 1;
            ic_addr = 32'hC0DE_D00D;


            repeat(3) @(posedge clk);

            #1;
            data_in = 32'h8888_9999;
            data_in_ready = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hC0DE_D00D, data_rd, 32'h8888_9999, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: No request active (Idle Check)", test_num);
            reset_dut();

            ic_rq = 0;
            ic_addr = 32'hFFFF_FFFF;
            data_in = 32'h1111_1111;
            data_in_ready = 0;

            @(posedge clk);
            #1;




            if (ic_data_out_valid === 1'b0 && data_rd === 1'b0) begin
                $display("PASS: Module idle as expected");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Module should be idle (valid=%b, rd=%b)", ic_data_out_valid, data_rd);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Data ready without active request", test_num);
            reset_dut();

            ic_rq = 0;
            data_in = 32'hFEED_FACE;
            data_in_ready = 1;

            @(posedge clk);
            #1;


            if (ic_data_out_valid === 1'b0) begin
                $display("PASS: No valid signal without request");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Valid signal high without request");
                fail_count = fail_count + 1;
            end
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
        input [31:0] expected_data_address;
        input expected_data_rd;
        input [31:0] expected_ic_data_out;
        input expected_ic_data_out_valid;
        begin
            if (expected_data_address === (expected_data_address ^ data_address ^ expected_data_address) &&
                expected_data_rd === (expected_data_rd ^ data_rd ^ expected_data_rd) &&
                expected_ic_data_out === (expected_ic_data_out ^ ic_data_out ^ expected_ic_data_out) &&
                expected_ic_data_out_valid === (expected_ic_data_out_valid ^ ic_data_out_valid ^ expected_ic_data_out_valid)) begin
                $display("PASS");
                $display("  Outputs: data_address=%h, data_rd=%b, ic_data_out=%h, ic_data_out_valid=%b",
                         data_address, data_rd, ic_data_out, ic_data_out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_address=%h, data_rd=%b, ic_data_out=%h, ic_data_out_valid=%b",
                         expected_data_address, expected_data_rd, expected_ic_data_out, expected_ic_data_out_valid);
                $display("  Got:      data_address=%h, data_rd=%b, ic_data_out=%h, ic_data_out_valid=%b",
                         data_address, data_rd, ic_data_out, ic_data_out_valid);
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
        $dumpvars(0,clk, data_in, data_in_ready, ic_addr, ic_rq, reset, data_address, data_rd, ic_data_out, ic_data_out_valid);
    end

endmodule
