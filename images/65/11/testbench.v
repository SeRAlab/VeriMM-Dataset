`timescale 1ns/1ps

module shift_register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg serial_in;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit dut (
        .clk(clk),
        .rst(rst),
        .serial_in(serial_in),
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
            rst = 1;
            serial_in = 0;
            @(negedge clk);
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Testcase %03d: Shift in all 1s", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                serial_in = 1;
                @(negedge clk);
            end
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        reg [7:0] pattern;
        integer i;
        begin
            test_num = 3;
            pattern = 8'hA5;
            $display("Testcase %03d: Shift in pattern 0x%h", test_num, pattern);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                serial_in = pattern[i];
                @(negedge clk);
            end
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %03d: Shift single bit to LSB", test_num);
            reset_dut();

            serial_in = 1;
            @(negedge clk);

            serial_in = 0;
            repeat(7) @(negedge clk);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Synchronous reset during operation", test_num);
            reset_dut();

            serial_in = 1;
            repeat(4) @(negedge clk);

            rst = 1;
            @(negedge clk);
            rst = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        reg [7:0] pattern;
        integer i;
        begin
            test_num = 6;
            pattern = 8'h5A;
            $display("Testcase %03d: Shift in pattern 0x%h", test_num, pattern);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                serial_in = pattern[i];
                @(negedge clk);
            end
            #1;

            check_outputs(8'h5A);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_8bit Testbench");
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, rst, serial_in, q);
    end

endmodule
