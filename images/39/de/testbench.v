`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg ld;
    reg rst;
    reg sl;
    reg sr;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .ld(ld),
        .rst(rst),
        .sl(sl),
        .sr(sr),
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
            ld = 0;
            sl = 0;
            sr = 0;
            data_in = 16'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test 001: Reset");
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Test 002: Parallel Load");
            reset_dut();
            data_in = 16'hA5A5;
            ld = 1;
            @(posedge clk);
            #1;
            ld = 0;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase003;

        begin
            $display("Test 003: Shift Left Once");
            reset_dut();
            data_in = 16'h0001;
            ld = 1;
            @(posedge clk);
            #1;
            ld = 0;
            sl = 1;
            @(posedge clk);
            #1;
            sl = 0;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            $display("Test 004: Shift Left 4 bits");
            reset_dut();
            data_in = 16'h000F;
            ld = 1;
            @(posedge clk);
            #1;
            ld = 0;
            sl = 1;
            repeat(4) @(posedge clk);
            #1;
            sl = 0;
            #1;

            check_outputs(16'h00F0);
        end
        endtask

    task testcase005;

        begin
            $display("Test 005: Shift Right Once");
            reset_dut();
            data_in = 16'h8000;
            ld = 1;
            @(posedge clk);
            #1;
            ld = 0;
            sr = 1;
            @(posedge clk);
            #1;
            sr = 0;
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase006;

        begin
            $display("Test 006: Shift Right 8 bits");
            reset_dut();
            data_in = 16'hFF00;
            ld = 1;
            @(posedge clk);
            #1;
            ld = 0;
            sr = 1;
            repeat(8) @(posedge clk);
            #1;
            sr = 0;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase007;

        begin
            $display("Test 007: Shift Left Out of Bounds");
            reset_dut();
            data_in = 16'h8000;
            ld = 1;
            @(posedge clk);
            #1;
            ld = 0;
            sl = 1;
            @(posedge clk);
            #1;
            sl = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            $display("Test 008: Shift Right Out of Bounds");
            reset_dut();
            data_in = 16'h0001;
            ld = 1;
            @(posedge clk);
            #1;
            ld = 0;
            sr = 1;
            @(posedge clk);
            #1;
            sr = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase009;

        begin
            $display("Test 009: Load Priority over Shift");
            reset_dut();
            data_in = 16'h1234;
            ld = 1;
            sl = 1;
            @(posedge clk);
            #1;
            ld = 0;
            sl = 0;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase010;

        begin
            $display("Test 010: Reset Priority");
            reset_dut();
            data_in = 16'hFFFF;
            ld = 1;
            @(posedge clk);
            #1;

            rst = 1;
            ld = 1;
            data_in = 16'hAAAA;
            sl = 1;
            @(posedge clk);
            #1;
            rst = 0;
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
        $dumpvars(0,clk, data_in, ld, rst, sl, sr, data_out);
    end

endmodule
