`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg shift_left;
    reg shift_right;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            shift_left = 0;
            shift_right = 0;
            data_in = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 32'h12345678;
            shift_left = 0;
            shift_right = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Load Data 0x12345678", test_num);
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();

            data_in = 32'h00000001;
            shift_left = 0;
            shift_right = 0;
            @(posedge clk);

            shift_left = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Shift Left 0x00000001 -> 0x00000002", test_num);
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            data_in = 32'h00000002;
            shift_left = 0;
            shift_right = 0;
            @(posedge clk);

            shift_right = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Shift Right 0x00000002 -> 0x00000001", test_num);
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            data_in = 32'h80000000;
            shift_left = 0;
            shift_right = 0;
            @(posedge clk);

            shift_right = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Shift Right 0x80000000 -> 0xC0000000 (Sign extension)", test_num);
            #1;

            check_outputs(32'hC0000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            data_in = 32'hF0000000;
            shift_left = 0;
            shift_right = 0;
            @(posedge clk);

            shift_right = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase %0d: Shift Right 0xF0000000 twice -> 0xFC000000", test_num);
            #1;

            check_outputs(32'hFC000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 32'h40000000;
            shift_left = 0;
            shift_right = 0;
            @(posedge clk);
            shift_left = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Shift Left 0x40000000 -> 0x80000000", test_num);
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 32'h0000FFFF;
            shift_left = 0; shift_right = 0;
            @(posedge clk);
            shift_left = 1;
            @(posedge clk);
            shift_left = 0; shift_right = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Sequence Left then Right 0x0000FFFF", test_num);
            #1;

            check_outputs(32'h0000FFFF);
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
        input [31:0] expected_q;
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
        $dumpvars(0,clk, data_in, shift_left, shift_right, q);
    end

endmodule
