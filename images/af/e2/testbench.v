`timescale 1ns/1ps

module bidirectional_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg en;
    reg [5:0] parallel_data;
    reg rst;
    wire [5:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bidirectional_shift_register dut (
        .clk(clk),
        .dir(dir),
        .en(en),
        .parallel_data(parallel_data),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            dir = 0;
            parallel_data = 6'b0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Synchronous Reset");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(6'b000000);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Parallel Load");
            test_num = 2;
            reset_dut();
            parallel_data = 6'b101101;
            en = 1;


            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b101101);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Shift Left");
            test_num = 3;
            reset_dut();

            parallel_data = 6'b000001;
            en = 1;
            @(posedge clk); #1;

            dir = 1;
            parallel_data = 6'b000000;
            @(posedge clk); #1;
            #1;

            check_outputs(6'b000010);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Shift Right");
            test_num = 4;
            reset_dut();

            parallel_data = 6'b100000;
            en = 1;
            @(posedge clk); #1;

            dir = 0;
            parallel_data = 6'b000000;
            @(posedge clk); #1;
            #1;

            check_outputs(6'b010000);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Multi-bit Shift Left");
            test_num = 5;
            reset_dut();
            parallel_data = 6'b000011;
            en = 1;
            @(posedge clk); #1;
            dir = 1;
            parallel_data = 6'b000000;
            @(posedge clk); #1;
            @(posedge clk); #1;
            #1;

            check_outputs(6'b001100);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Enable Control (Hold)");
            test_num = 6;
            reset_dut();
            parallel_data = 6'b111111;
            en = 1;
            @(posedge clk); #1;
            en = 0;
            dir = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(6'b111111);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Reset Priority");
            test_num = 7;
            reset_dut();
            parallel_data = 6'b101010;
            en = 1;
            @(posedge clk); #1;
            rst = 1;
            dir = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(6'b000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bidirectional_shift_register Testbench");
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
        input [5:0] expected_q;
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
        $dumpvars(0,clk, dir, en, parallel_data, rst, q);
    end

endmodule
