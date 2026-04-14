`timescale 1ns/1ps

module crc32_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg reset;
    reg start;
    wire [31:0] crc_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc32_generator dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .crc_out(crc_out),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        start = 0;
        data_in = 32'h0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %03d: Data = 0x00000000", test_num);
        reset_dut();
        data_in = 32'h00000000;
        start = 1;
        @(posedge clk);
        start = 0;


        wait(done === 1'b1);
        @(posedge clk);
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %03d: Data = 0x80000000 (MSB set)", test_num);
        reset_dut();
        data_in = 32'h80000000;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done === 1'b1);
        @(posedge clk);
        #1;

        check_outputs(32'h04C11DB7, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %03d: Data = 0xFFFFFFFF", test_num);
        reset_dut();
        data_in = 32'hFFFFFFFF;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done === 1'b1);
        @(posedge clk);
        #1;

        check_outputs(32'h030D2650, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %03d: Data = 0x12345678", test_num);
        reset_dut();
        data_in = 32'h12345678;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done === 1'b1);
        @(posedge clk);
        #1;

        check_outputs(32'h9099839F, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %03d: Data = 0xA5A5A5A5", test_num);
        reset_dut();
        data_in = 32'hA5A5A5A5;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done === 1'b1);
        @(posedge clk);
        #1;

        check_outputs(32'h5140F375, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc32_generator Testbench");
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
        input [31:0] expected_crc_out;
        input expected_done;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h, done=%b",
                         crc_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h, done=%b",
                         expected_crc_out, expected_done);
                $display("  Got:      crc_out=%h, done=%b",
                         crc_out, done);
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
        $dumpvars(0,clk, data_in, reset, start, crc_out, done);
    end

endmodule
