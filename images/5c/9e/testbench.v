`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst_n;
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
        .rst_n(rst_n),
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
        rst_n = 0;
        shift_left = 0;
        shift_right = 0;
        data_in = 8'b0;
        @(posedge clk);
        #1 rst_n = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase001: Reset check...");
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase002: Shift Left (filling with 1s)...");
        reset_dut();
        data_in = 8'h01;
        shift_left = 1;
        shift_right = 0;
        repeat(8) @(posedge clk);
        #1 #1;
 check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase003: Shift Right (filling with 1s)...");
        reset_dut();
        data_in = 8'h80;
        shift_left = 0;
        shift_right = 1;
        repeat(4) @(posedge clk);
        #1 #1;
 check_outputs(8'hF0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase004: Data Hold (no shift signals)...");
        reset_dut();

        data_in = 8'h01;
        shift_left = 1;
        @(posedge clk);
        #1;

        shift_left = 0;
        shift_right = 0;
        repeat(4) @(posedge clk);
        #1 #1;
 check_outputs(8'h01);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase005: Left shift then Right shift...");
        reset_dut();

        data_in = 8'h01;
        shift_left = 1;
        repeat(4) @(posedge clk);
        #1;

        data_in = 8'h00;
        shift_left = 0;
        shift_right = 1;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(8'h03);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase006: Priority Check (both signals high)...");
        reset_dut();
        data_in = 8'h01;
        shift_left = 1;
        shift_right = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h01);
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
        $dumpvars(0,clk, data_in, rst_n, shift_left, shift_right, data_out);
    end

endmodule
