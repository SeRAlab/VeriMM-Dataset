`timescale 1ns/1ps

module shiftreg8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg rst;
    reg shift;
    reg shift_dir;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shiftreg8bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst(rst),
        .shift(shift),
        .shift_dir(shift_dir),
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
        shift = 0;
        shift_dir = 0;
        data_in = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Initial Reset", test_num);
        reset_dut();
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Parallel Load 8'hAA", test_num);
        reset_dut();
        data_in = 8'hAA;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load 8'h01 and Shift Left", test_num);
        reset_dut();

        data_in = 8'h01;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        shift = 1;
        shift_dir = 1;
        @(posedge clk);
        #1 shift = 0;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load 8'h80 and Shift Right", test_num);
        reset_dut();

        data_in = 8'h80;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        shift = 1;
        shift_dir = 0;
        @(posedge clk);
        #1 shift = 0;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple Shift Left (8'h0F -> 8'hF0)", test_num);
        reset_dut();

        data_in = 8'h0F;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        shift = 1;
        shift_dir = 1;
        repeat(4) @(posedge clk);
        #1 shift = 0;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple Shift Right (8'hF0 -> 8'h0F)", test_num);
        reset_dut();

        data_in = 8'hF0;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        shift = 1;
        shift_dir = 0;
        repeat(4) @(posedge clk);
        #1 shift = 0;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load priority over Shift", test_num);
        reset_dut();

        data_in = 8'h55;
        load = 1;
        shift = 1;
        shift_dir = 1;
        @(posedge clk);
        #1 load = 0; shift = 0;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Left boundary", test_num);
        reset_dut();
        data_in = 8'h80;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift = 1;
        shift_dir = 1;
        @(posedge clk);
        #1 shift = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Right boundary", test_num);
        reset_dut();
        data_in = 8'h01;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift = 1;
        shift_dir = 0;
        @(posedge clk);
        #1 shift = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: No Enable signals", test_num);
        reset_dut();
        data_in = 8'h3C;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift = 0;

        repeat(2) @(posedge clk);
        #1;

        check_outputs(8'h3C);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shiftreg8bit Testbench");
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, load, rst, shift, shift_dir, data_out);
    end

endmodule
