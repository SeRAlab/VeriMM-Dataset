`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] m_ready;
    reg resetn;
    reg s_valid;
    wire [1:0] m_valid;
    wire s_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .m_ready(m_ready),
        .resetn(resetn),
        .s_valid(s_valid),
        .m_valid(m_valid),
        .s_ready(s_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            s_valid = 0;
            m_ready = 2'b00;
            repeat(2) @(posedge clk);
            #1 resetn = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            s_valid = 0;
            m_ready = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            s_valid = 1;
            m_ready = 2'b11;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            s_valid = 1;
            m_ready = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b11, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            s_valid = 1;
            m_ready = 2'b01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b11, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            s_valid = 1;
            m_ready = 2'b10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b11, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            s_valid = 0;
            m_ready = 2'b11;
            @(posedge clk);
            #1;



            #1;




            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            s_valid = 1;
            m_ready = 2'b01;
            @(posedge clk);
            #1;
            m_ready = 2'b11;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b11, 1'b1);
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
        input [1:0] expected_m_valid;
        input expected_s_ready;
        begin
            if (expected_m_valid === (expected_m_valid ^ m_valid ^ expected_m_valid) &&
                expected_s_ready === (expected_s_ready ^ s_ready ^ expected_s_ready)) begin
                $display("PASS");
                $display("  Outputs: m_valid=%h, s_ready=%b",
                         m_valid, s_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_valid=%h, s_ready=%b",
                         expected_m_valid, expected_s_ready);
                $display("  Got:      m_valid=%h, s_ready=%b",
                         m_valid, s_ready);
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
        $dumpvars(0,clk, m_ready, resetn, s_valid, m_valid, s_ready);
    end

endmodule
