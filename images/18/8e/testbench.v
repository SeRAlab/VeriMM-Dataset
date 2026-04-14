`timescale 1ns/1ps

module divide_by_8_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divide_by_8 dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            data_in = 8'd0;
            @(posedge clk);
            #1;
            $display("Test Case 001: Input 0");
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            data_in = 8'd8;
            @(posedge clk);
            #1;
            $display("Test Case 002: Input 8");
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            data_in = 8'd16;
            @(posedge clk);
            #1;
            $display("Test Case 003: Input 16");
            #1;

            check_outputs(8'd2);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            data_in = 8'd24;
            @(posedge clk);
            #1;
            $display("Test Case 004: Input 24");
            #1;

            check_outputs(8'd3);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            data_in = 8'd7;
            @(posedge clk);
            #1;
            $display("Test Case 005: Input 7 (Floor division)");
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            data_in = 8'd15;
            @(posedge clk);
            #1;
            $display("Test Case 006: Input 15 (Floor division)");
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            data_in = 8'd255;
            @(posedge clk);
            #1;
            $display("Test Case 007: Input 255");
            #1;

            check_outputs(8'd31);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            data_in = 8'd80;
            @(posedge clk);
            #1;
            $display("Test Case 008: Input 80");
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            data_in = 8'd1;
            @(posedge clk);
            #1;
            $display("Test Case 009: Input 1");
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            data_in = 8'd64;
            @(posedge clk);
            #1;
            $display("Test Case 010: Input 64");
            #1;

            check_outputs(8'd8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divide_by_8 Testbench");
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
        $dumpvars(0,clk, data_in, reset, data_out);
    end

endmodule
