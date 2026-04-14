`timescale 1ns/1ps

module Shift_reg_16_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg serial_in;
    wire [15:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Shift_reg_16 dut (
        .clk(clk),
        .rst_n(rst_n),
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
            rst_n = 0;
            serial_in = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Reset", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift in a single '1'", test_num);
            reset_dut();
            serial_in = 1;
            @(posedge clk);
            #1;
            serial_in = 0;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Fill register with sixteen '1's", test_num);
            reset_dut();
            serial_in = 1;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        reg [15:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift in pattern 0xA5A5", test_num);
            reset_dut();
            pattern = 16'hA5A5;
            for (i = 15; i >= 0; i = i - 1) begin
                serial_in = pattern[i];
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify overflow (Shift 20 bits)", test_num);
            reset_dut();


            serial_in = 1;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                #1;
            end


            serial_in = 0;
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                #1;
            end



            #1;




            check_outputs(16'hFFF0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits check", test_num);
            reset_dut();
            for (i = 0; i < 16; i = i + 1) begin
                serial_in = i[0];
                @(posedge clk);
                #1;
            end



            #1;




            check_outputs(16'h5555);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Shift_reg_16 Testbench");
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
        input [15:0] expected_parallel_out;
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
        $dumpvars(0,clk, rst_n, serial_in, parallel_out);
    end

endmodule
