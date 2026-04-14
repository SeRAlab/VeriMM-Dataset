`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg eack;
    reg stb;
    reg sys_clk;
    reg sys_rst;
    reg we;
    wire ack;
    wire stbm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .eack(eack),
        .stb(stb),
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .we(we),
        .ack(ack),
        .stbm(stbm)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            sys_rst = 1;
            stb = 0;
            eack = 0;
            we = 0;
            @(posedge sys_clk);
            #1 sys_rst = 0;
            @(posedge sys_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Write Operation", test_num);
            reset_dut();

            stb = 1;
            we = 1;
            @(posedge sys_clk);
            #1 eack = 1;

            @(posedge sys_clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Read Operation", test_num);
            reset_dut();

            stb = 1;
            we = 0;
            @(posedge sys_clk);
            #1 eack = 1;

            @(posedge sys_clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle State", test_num);
            reset_dut();

            stb = 0;
            eack = 0;
            @(posedge sys_clk);

            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Strobe Active No Ack", test_num);
            reset_dut();

            stb = 1;
            eack = 0;
            @(posedge sys_clk);

            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during Transaction", test_num);
            reset_dut();

            stb = 1;
            eack = 1;
            @(posedge sys_clk);

            sys_rst = 1;
            @(posedge sys_clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Delayed Acknowledgment", test_num);
            reset_dut();

            stb = 1;
            eack = 0;
            repeat(2) @(posedge sys_clk);

            #1 eack = 1;
            @(posedge sys_clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_ack;
        input expected_stbm;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_stbm === (expected_stbm ^ stbm ^ expected_stbm)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, stbm=%b",
                         ack, stbm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, stbm=%b",
                         expected_ack, expected_stbm);
                $display("  Got:      ack=%b, stbm=%b",
                         ack, stbm);
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
        $dumpvars(0,eack, stb, sys_clk, sys_rst, we, ack, stbm);
    end

endmodule
