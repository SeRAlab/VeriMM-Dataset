`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [7:0] in;
    reg pe_request;
    wire [2:0] out;
    wire pe_work;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .in(in),
        .pe_request(pe_request),
        .out(out),
        .pe_work(pe_work)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            pe_request = 0;
            in = 8'b0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            in = 8'b1000_0000;
            pe_request = 1;
            @(posedge clock);
            #1;
            pe_request = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            in = 8'b0000_0001;
            pe_request = 1;
            @(posedge clock);
            #1;
            pe_request = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(3'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            in = 8'b0110_1010;
            pe_request = 1;
            @(posedge clock);
            #1;
            pe_request = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(3'd6, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            in = 8'b0001_0000;
            pe_request = 1;
            @(posedge clock);
            #1;
            pe_request = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(3'd4, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            in = 8'b0000_0110;
            pe_request = 1;
            @(posedge clock);
            #1;
            pe_request = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(3'd2, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            in = 8'b1111_1111;
            pe_request = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(3'd0, 1'b1);
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
        input [2:0] expected_out;
        input expected_pe_work;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_pe_work === (expected_pe_work ^ pe_work ^ expected_pe_work)) begin
                $display("PASS");
                $display("  Outputs: out=%h, pe_work=%b",
                         out, pe_work);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, pe_work=%b",
                         expected_out, expected_pe_work);
                $display("  Got:      out=%h, pe_work=%b",
                         out, pe_work);
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
        $dumpvars(0,clock, in, pe_request, out, pe_work);
    end

endmodule
