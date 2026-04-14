`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg sreset;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .sreset(sreset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sreset = 1;
            @(posedge clk);
            #1;
            sreset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running testcase%03d: Initial Reset", test_num);
            reset_dut();
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running testcase%03d: Single Increment", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Running testcase%03d: Increment to 4", test_num);
            reset_dut();
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Running testcase%03d: Increment to Max (7)", test_num);
            reset_dut();
            for (i = 0; i < 7; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Running testcase%03d: Roll-over check (8 cycles)", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Running testcase%03d: Synchronous Reset while counting", test_num);
            reset_dut();

            for (i = 0; i < 3; i = i + 1) begin
                @(posedge clk);
            end

            sreset = 1;
            @(posedge clk);
            #1;
            sreset = 0;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("Running testcase%03d: 10 increments (roll-over + 2)", test_num);
            reset_dut();
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(3'd2);
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
        input [2:0] expected_q;
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
        $dumpvars(0,clk, sreset, q);
    end

endmodule
