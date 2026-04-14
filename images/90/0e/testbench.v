`timescale 1ns/1ps

module shift_reg_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg serial_in;
    wire [7:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_8bit dut (
        .clk(clk),
        .rst(rst),
        .serial_in(serial_in),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            serial_in = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Synchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Testcase %0d: Shifting in 8 consecutive ones", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                serial_in = 1;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = 3;
            pattern = 8'b10101010;
            $display("Testcase %0d: Shifting in pattern 0xAA", test_num);
            reset_dut();

            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = pattern[0];

            end

            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 0;
            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 0;
            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 0;
            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 0;
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Shifting in 4 ones (Partial Fill)", test_num);
            reset_dut();
            repeat(4) begin
                serial_in = 1;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Shifting 9 times to verify data displacement", test_num);
            reset_dut();

            serial_in = 1;
            @(posedge clk);

            repeat(8) begin
                serial_in = 0;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        integer i;
        reg [7:0] data_to_shift;
        begin
            test_num = 6;
            data_to_shift = 8'h3C;
            $display("Testcase %0d: Shifting in 0x3C", test_num);
            reset_dut();

            serial_in = 0; @(posedge clk);
            serial_in = 0; @(posedge clk);
            serial_in = 1; @(posedge clk);
            serial_in = 1; @(posedge clk);
            serial_in = 1; @(posedge clk);
            serial_in = 1; @(posedge clk);
            serial_in = 0; @(posedge clk);
            serial_in = 0; @(posedge clk);
            #1;
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
        $display("shift_reg_8bit Testbench");
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
        input [7:0] expected_parallel_out;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h",
                         parallel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h",
                         expected_parallel_out);
                $display("  Got:      parallel_out=%h",
                         parallel_out);
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
        $dumpvars(0,clk, rst, serial_in, parallel_out);
    end

endmodule
