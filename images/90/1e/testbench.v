`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_ready;
    reg m_arready;
    reg next_pending;
    reg reset;
    reg [7:0] s_arlen;
    reg s_arvalid;
    wire a_push;
    wire m_arvalid;
    wire next;
    wire r_push;
    wire s_arready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_ready(data_ready),
        .m_arready(m_arready),
        .next_pending(next_pending),
        .reset(reset),
        .s_arlen(s_arlen),
        .s_arvalid(s_arvalid),
        .a_push(a_push),
        .m_arvalid(m_arvalid),
        .next(next),
        .r_push(r_push),
        .s_arready(s_arready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            s_arvalid = 0;
            s_arlen = 0;
            m_arready = 0;
            next_pending = 0;
            data_ready = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial state check");
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0, 1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Full Single Transaction");
            reset_dut();

            s_arvalid = 1;
            s_arlen = 8'h04;
            data_ready = 1;
            m_arready = 1;


            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);


            #1;



            check_outputs(0, 0, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Wait for data_ready");
            reset_dut();

            s_arvalid = 1;
            data_ready = 0;
            m_arready = 1;

            repeat(3) @(posedge clk);

            data_ready = 1;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs(0, 0, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Wait for m_arready");
            reset_dut();

            s_arvalid = 1;
            data_ready = 1;
            m_arready = 0;

            @(posedge clk);
            repeat(2) @(posedge clk);

            m_arready = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs(0, 0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Transaction with next_pending set");
            reset_dut();

            s_arvalid = 1;
            data_ready = 1;
            m_arready = 1;
            next_pending = 1;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);




            @(posedge clk);


            #1;



            check_outputs(0, 0, 0, 0, 1);
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
        input expected_a_push;
        input expected_m_arvalid;
        input expected_next;
        input expected_r_push;
        input expected_s_arready;
        begin
            if (expected_a_push === (expected_a_push ^ a_push ^ expected_a_push) &&
                expected_m_arvalid === (expected_m_arvalid ^ m_arvalid ^ expected_m_arvalid) &&
                expected_next === (expected_next ^ next ^ expected_next) &&
                expected_r_push === (expected_r_push ^ r_push ^ expected_r_push) &&
                expected_s_arready === (expected_s_arready ^ s_arready ^ expected_s_arready)) begin
                $display("PASS");
                $display("  Outputs: a_push=%b, m_arvalid=%b, next=%b, r_push=%b, s_arready=%b",
                         a_push, m_arvalid, next, r_push, s_arready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_push=%b, m_arvalid=%b, next=%b, r_push=%b, s_arready=%b",
                         expected_a_push, expected_m_arvalid, expected_next, expected_r_push, expected_s_arready);
                $display("  Got:      a_push=%b, m_arvalid=%b, next=%b, r_push=%b, s_arready=%b",
                         a_push, m_arvalid, next, r_push, s_arready);
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
        $dumpvars(0,clk, data_ready, m_arready, next_pending, reset, s_arlen, s_arvalid, a_push, m_arvalid, next, r_push, s_arready);
    end

endmodule
