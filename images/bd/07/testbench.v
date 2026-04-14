`timescale 1ns/1ps

module shift_reg_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg dir;
    reg load;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_16bit dut (
        .clk(clk),
        .data_in(data_in),
        .dir(dir),
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
        @(negedge clk);
        load = 1;
        data_in = 16'h0000;
        dir = 0;
        @(negedge clk);
        load = 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Parallel Load 0xACE1");
        test_num = test_num + 1;
        @(negedge clk);
        load = 1;
        data_in = 16'hACE1;
        @(negedge clk);
        load = 0;
        #1;
        #1;

        check_outputs(16'hACE1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Shift Left Once (0x0001 -> 0x0002)");
        test_num = test_num + 1;

        @(negedge clk);
        load = 1;
        data_in = 16'h0001;
        @(negedge clk);
        load = 0;
        dir = 0;
        @(negedge clk);
        #1;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase 003: Shift Right Once (0x8000 -> 0x4000)");
        test_num = test_num + 1;

        @(negedge clk);
        load = 1;
        data_in = 16'h8000;
        @(negedge clk);
        load = 0;
        dir = 1;
        @(negedge clk);
        #1;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase 004: Shift Left 4 times (0x000F -> 0x00F0)");
        test_num = test_num + 1;
        @(negedge clk);
        load = 1;
        data_in = 16'h000F;
        @(negedge clk);
        load = 0;
        dir = 0;
        repeat(4) @(negedge clk);
        #1;
        #1;

        check_outputs(16'h00F0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Shift Right 8 times (0xFF00 -> 0x00FF)");
        test_num = test_num + 1;
        @(negedge clk);
        load = 1;
        data_in = 16'hFF00;
        @(negedge clk);
        load = 0;
        dir = 1;
        repeat(8) @(negedge clk);
        #1;
        #1;

        check_outputs(16'h00FF);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        $display("Testcase 006: Shift Right until empty (0x0001 -> 0x0000)");
        test_num = test_num + 1;
        @(negedge clk);
        load = 1;
        data_in = 16'h0001;
        @(negedge clk);
        load = 0;
        dir = 1;
        @(negedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_16bit Testbench");
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
        input [15:0] expected_q;
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
        $dumpvars(0,clk, data_in, dir, load, q);
    end

endmodule
