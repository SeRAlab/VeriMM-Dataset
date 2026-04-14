`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] DATA_IN;
    reg [1:0] SHIFT;
    reg clk;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATA_IN(DATA_IN),
        .SHIFT(SHIFT),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            DATA_IN = 4'b0000;
            SHIFT = 2'b00;
            repeat(8) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Johnson State 1 (1000), No Shift", test_num);
            reset_dut();
            DATA_IN = 4'b1111;
            SHIFT = 2'b00;
            @(posedge clk); #1;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Johnson State 2 (1100), Right Shift", test_num);
            reset_dut();
            DATA_IN = 4'b1111;
            SHIFT = 2'b01;
            repeat(2) @(posedge clk); #1;
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Johnson State 3 (1110), Left Shift", test_num);
            reset_dut();
            DATA_IN = 4'b1111;
            SHIFT = 2'b10;
            repeat(3) @(posedge clk); #1;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Johnson State 4 (1111), No Shift, Masking", test_num);
            reset_dut();
            DATA_IN = 4'b1010;
            SHIFT = 2'b00;
            repeat(4) @(posedge clk); #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Johnson State 5 (0111), Right Shift", test_num);
            reset_dut();
            DATA_IN = 4'b1111;
            SHIFT = 2'b01;
            repeat(5) @(posedge clk); #1;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Johnson State 6 (0011), Left Shift", test_num);
            reset_dut();
            DATA_IN = 4'b1111;
            SHIFT = 2'b10;
            repeat(6) @(posedge clk); #1;
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Johnson State 4 (1111), Right Shift, Complex Mask", test_num);
            reset_dut();
            DATA_IN = 4'b0101;
            SHIFT = 2'b01;
            repeat(4) @(posedge clk); #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Johnson State 8 (0000), Wrap-around", test_num);
            reset_dut();
            DATA_IN = 4'b1111;
            SHIFT = 2'b00;
            repeat(8) @(posedge clk); #1;
            #1;

            check_outputs(4'h0);
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,DATA_IN, SHIFT, clk, Q);
    end

endmodule
