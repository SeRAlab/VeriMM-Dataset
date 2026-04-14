`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data;
    reg reset;
    reg [4:0] shift_amt;
    wire [31:0] shifted_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .shift_amt(shift_amt),
        .shifted_data(shifted_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data = 32'hDEADBEEF;
            shift_amt = 5'b00000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data = 32'hA5A5A5A5;
            shift_amt = 5'b10000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data = 32'h80000000;
            shift_amt = 5'b00001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data = 32'h00000001;
            shift_amt = 5'b10001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data = 32'h12345678;
            shift_amt = 5'b01000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00123456);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data = 32'h12345678;
            shift_amt = 5'b11000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h34567800);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            data = 32'hFFFFFFFF;
            shift_amt = 5'b01111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0001FFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            data = 32'hFFFFFFFF;
            shift_amt = 5'b11111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFF8000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            data = 32'hAAAAAAAA;
            shift_amt = 5'b00100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0AAAAAAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_shifted_data;
        begin
            if (expected_shifted_data === (expected_shifted_data ^ shifted_data ^ expected_shifted_data)) begin
                $display("PASS");
                $display("  Outputs: shifted_data=%h",
                         shifted_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted_data=%h",
                         expected_shifted_data);
                $display("  Got:      shifted_data=%h",
                         shifted_data);
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
        $dumpvars(0,clk, data, reset, shift_amt, shifted_data);
    end

endmodule
