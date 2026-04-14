`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg clk;
    reg rst;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .clk(clk),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            D = 0;
            @(posedge clk);
            #1;
            rst = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Reset to Zero", test_num);
            reset_dut();
            rst = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in eight 1s (0xFF)", test_num);
            reset_dut();
            repeat(8) begin
                D = 1;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in sequence 1-0-1-0-1-0-1-0 (0xAA)", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                D = (i % 2 == 0) ? 1 : 0;
                @(posedge clk);
            end
            #1;



            #1;




            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in sequence 0-1-0-1-0-1-0-1 (0x55)", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                D = (i % 2 == 0) ? 0 : 1;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Propagate a single 1 to MSB (0x80)", test_num);
            reset_dut();

            D = 1;
            @(posedge clk);

            D = 0;
            repeat(7) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Partial shift 4 bits (0x0F)", test_num);
            reset_dut();
            repeat(4) begin
                D = 1;
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(8'h0F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset mid-operation", test_num);
            reset_dut();
            repeat(4) begin
                D = 1;
                @(posedge clk);
            end
            rst = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, clk, rst, Q);
    end

endmodule
