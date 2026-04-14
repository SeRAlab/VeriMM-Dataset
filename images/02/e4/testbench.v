`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg shift_left;
    reg shift_right;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
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
        load = 1;
        data_in = 8'h00;
        shift_left = 0;
        shift_right = 0;
        @(posedge clk);
        #1;
        load = 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("\nTestcase %0d: Parallel Load", test_num);
        load = 1;
        data_in = 8'hA5;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("\nTestcase %0d: Single Shift Left", test_num);

        load = 1;
        data_in = 8'h01;
        @(posedge clk);
        #1;
        load = 0;

        shift_left = 1;
        @(posedge clk);
        #1;
        shift_left = 0;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("\nTestcase %0d: Multiple Shift Left", test_num);
        load = 1;
        data_in = 8'h07;
        @(posedge clk);
        #1;
        load = 0;
        shift_left = 1;
        repeat(4) @(posedge clk);
        #1;
        shift_left = 0;
        #1;

        check_outputs(8'h70);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("\nTestcase %0d: Single Shift Right", test_num);
        load = 1;
        data_in = 8'h80;
        @(posedge clk);
        #1;
        load = 0;
        shift_right = 1;
        @(posedge clk);
        #1;
        shift_right = 0;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("\nTestcase %0d: Multiple Shift Right", test_num);
        load = 1;
        data_in = 8'hF0;
        @(posedge clk);
        #1;
        load = 0;
        shift_right = 1;
        repeat(4) @(posedge clk);
        #1;
        shift_right = 0;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("\nTestcase %0d: Shift Right until empty", test_num);
        load = 1;
        data_in = 8'h01;
        @(posedge clk);
        #1;
        load = 0;
        shift_right = 1;
        @(posedge clk);
        #1;
        shift_right = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("\nTestcase %0d: Load Priority Over Shift", test_num);
        load = 1;
        shift_left = 1;
        data_in = 8'h55;
        @(posedge clk);
        #1;
        load = 0;
        shift_left = 0;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        $display("\nTestcase %0d: Complex Sequence Load->SL->SR", test_num);

        load = 1;
        data_in = 8'h0A;
        @(posedge clk);
        #1;
        load = 0;

        shift_left = 1;
        @(posedge clk);
        #1;
        shift_left = 0;

        shift_right = 1;
        repeat(2) @(posedge clk);
        #1;
        shift_right = 0;
        #1;

        check_outputs(8'h05);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,clk, data_in, load, shift_left, shift_right, data_out);
    end

endmodule
