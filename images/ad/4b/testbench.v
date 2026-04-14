`timescale 1ns/1ps

module shift_reg_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load;
    reg rst;
    reg shift_left;
    reg shift_right;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst(rst),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        load = 0;
        shift_left = 0;
        shift_right = 0;
        data_in = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Basic Reset");
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Parallel Load (0xACE1)");
        data_in = 16'hACE1;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        #1;

        check_outputs(16'hACE1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase 003: Shift Left (Load 0x0001 -> Shift Left)");
        data_in = 16'h0001;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift_left = 1;
        @(posedge clk);
        #1 shift_left = 0;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase 004: Shift Right (Load 0x8000 -> Shift Right)");
        data_in = 16'h8000;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift_right = 1;
        @(posedge clk);
        #1 shift_right = 0;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Multiple Shift Lefts");
        data_in = 16'hF000;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift_left = 1;
        repeat(4) @(posedge clk);
        #1 shift_left = 0;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        $display("Testcase 006: Multiple Shift Rights");
        data_in = 16'h000F;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift_right = 1;
        repeat(2) @(posedge clk);
        #1 shift_right = 0;

        #1;


        check_outputs(16'h0003);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        $display("Testcase 007: Load Priority (Load vs Shift Left)");
        data_in = 16'h5555;
        load = 1;
        shift_left = 1;
        @(posedge clk);
        #1 load = 0; shift_left = 0;

        #1;


        check_outputs(16'h5555);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        $display("Testcase 008: Shift Priority (Shift Left vs Shift Right)");

        data_in = 16'h00FF;
        load = 1;
        @(posedge clk);
        #1 load = 0;


        shift_left = 1;
        shift_right = 1;
        @(posedge clk);
        #1 shift_left = 0; shift_right = 0;

        #1;


        check_outputs(16'h01FE);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        $display("Testcase 009: Continuous Parallel Loading");
        load = 1;
        data_in = 16'h1111; @(posedge clk);
        data_in = 16'h2222; @(posedge clk);
        data_in = 16'h3333; @(posedge clk);
        #1 load = 0;
        #1;

        check_outputs(16'h3333);
    end
        endtask

    task testcase010;

    begin
        reset_dut();
        $display("Testcase 010: Reset overriding all signals");
        data_in = 16'hFFFF;
        load = 1;
        shift_left = 1;
        rst = 1;
        @(posedge clk);
        #1 rst = 0; load = 0; shift_left = 0;
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
        $display("shift_reg Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, load, rst, shift_left, shift_right, data_out);
    end

endmodule
