`timescale 1ns/1ps

module shift_register_8bit_tb;

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
    shift_register_8bit dut (
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
            rst = 1;
            serial_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in all 1s", test_num);
            reset_dut();
            serial_in = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        reg [7:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in 0xAA (10101010)", test_num);
            reset_dut();
            pattern = 8'hAA;
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = pattern[i];
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        reg [7:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in 0x55 (01010101)", test_num);
            reset_dut();
            pattern = 8'h55;
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = pattern[i];
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        reg [11:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow Test (12 shifts)", test_num);
            reset_dut();
            pattern = 12'hCA7;
            for (i = 11; i >= 0; i = i - 1) begin
                serial_in = pattern[i];
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'hA7);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Walk single '1' through register", test_num);
            reset_dut();


            serial_in = 1;
            @(posedge clk);

            serial_in = 0;
            for (i = 0; i < 7; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(8'h80);
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
