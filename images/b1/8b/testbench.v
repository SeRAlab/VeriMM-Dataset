`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] pc_in;
    reg reset;
    wire [31:0] pc_out;
    wire [2:0] tick;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .pc_in(pc_in),
        .reset(reset),
        .pc_out(pc_out),
        .tick(tick)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            pc_in = 32'h0;
            @(posedge clock);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Update at Tick 6", test_num);
            reset_dut();
            pc_in = 32'hDEADBEEF;


            repeat(6) @(posedge clock);
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 3'd6);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: No Update at Tick 5", test_num);
            reset_dut();
            pc_in = 32'h12345678;


            repeat(5) @(posedge clock);
            #1;
            #1;

            check_outputs(32'h00000000, 3'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Holding PC value at Tick 7", test_num);
            reset_dut();
            pc_in = 32'hAAAA_5555;


            repeat(6) @(posedge clock);

            pc_in = 32'hFFFF_FFFF;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hAAAA_5555, 3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Mid-count Reset", test_num);
            reset_dut();
            pc_in = 32'hBBBB_CCCC;

            repeat(3) @(posedge clock);
            reset = 1;
            @(posedge clock);
            #1;
            reset = 0;
            #1;

            check_outputs(32'h00000000, 3'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Wrap-around Update", test_num);
            reset_dut();


            pc_in = 32'h1111_1111;
            repeat(6) @(posedge clock);


            pc_in = 32'h2222_2222;

            repeat(8) @(posedge clock);
            #1;
            #1;

            check_outputs(32'h2222_2222, 3'd6);
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
        input [31:0] expected_pc_out;
        input [2:0] expected_tick;
        begin
            if (expected_pc_out === (expected_pc_out ^ pc_out ^ expected_pc_out) &&
                expected_tick === (expected_tick ^ tick ^ expected_tick)) begin
                $display("PASS");
                $display("  Outputs: pc_out=%h, tick=%h",
                         pc_out, tick);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_out=%h, tick=%h",
                         expected_pc_out, expected_tick);
                $display("  Got:      pc_out=%h, tick=%h",
                         pc_out, tick);
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
        $dumpvars(0,clock, pc_in, reset, pc_out, tick);
    end

endmodule
