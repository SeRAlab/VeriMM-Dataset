`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg load;
    wire [4:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            load <= 1;
            data_in <= 5'b0;
            @(posedge clk);
            load <= 0;
            data_in <= 5'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            load <= 1;
            data_in <= 5'b10111;
            @(posedge clk);
            load <= 0;
            #1;
            $display("Testcase 001: Parallel Load 0x17");
            #1;

            check_outputs(5'b10111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            @(posedge clk);
            load <= 1;
            data_in <= 5'b10001;
            @(posedge clk);

            load <= 0;
            @(posedge clk);
            #1;
            $display("Testcase 002: Load 0x11 then Shift Once");
            #1;

            check_outputs(5'b01000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(posedge clk);
            load <= 1;
            data_in <= 5'b00001;
            @(posedge clk);

            load <= 0;
            @(posedge clk);
            #1;
            $display("Testcase 003: Load 0x01 then Shift to 0x00");
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(posedge clk);
            load <= 1;
            data_in <= 5'b10110;
            @(posedge clk);

            load <= 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase 004: Load 0x16 then Shift Twice");
            #1;

            check_outputs(5'b00101);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(posedge clk);
            load <= 1;
            data_in <= 5'h0A;
            @(posedge clk);

            load <= 1;
            data_in <= 5'h1F;
            @(posedge clk);
            #1;
            $display("Testcase 005: Consecutive Parallel Loads");
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            @(posedge clk);
            load <= 1;
            data_in <= 5'b11111;
            @(posedge clk);
            load <= 0;
            repeat (5) @(posedge clk);
            #1;
            $display("Testcase 006: Load 0x1F then Shift 5 times");
            #1;

            check_outputs(5'b00000);
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
        input [4:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data_in, load, q);
    end

endmodule
