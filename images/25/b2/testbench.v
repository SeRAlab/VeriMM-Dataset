`timescale 1ns/1ps

module DWT_Haar_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] signal_in;
    wire [3:0] coeff_a;
    wire [3:0] coeff_d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DWT_Haar dut (
        .clk(clk),
        .rst(rst),
        .signal_in(signal_in),
        .coeff_a(coeff_a),
        .coeff_d(coeff_d)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            signal_in = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Inputs 8 and 4", test_num);
            reset_dut();
            signal_in = 4'd8;
            @(posedge clk);
            signal_in = 4'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd6, 4'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Inputs 10 and 10", test_num);
            reset_dut();
            signal_in = 4'd10;
            @(posedge clk);
            signal_in = 4'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd10, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Inputs 14 and 2", test_num);
            reset_dut();
            signal_in = 4'd14;
            @(posedge clk);
            signal_in = 4'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8, 4'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Inputs 0 and 0", test_num);
            reset_dut();
            signal_in = 4'd0;
            @(posedge clk);
            signal_in = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Inputs 15 and 0", test_num);
            reset_dut();
            signal_in = 4'd15;
            @(posedge clk);
            signal_in = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd7, 4'd7);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Inputs 4 and 8 (Negative Difference)", test_num);
            reset_dut();
            signal_in = 4'd4;
            @(posedge clk);
            signal_in = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd6, 4'hE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Inputs 15 and 15", test_num);
            reset_dut();
            signal_in = 4'd15;
            @(posedge clk);
            signal_in = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15, 4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DWT_Haar Testbench");
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
        input [3:0] expected_coeff_a;
        input [3:0] expected_coeff_d;
        begin
            if (expected_coeff_a === (expected_coeff_a ^ coeff_a ^ expected_coeff_a) &&
                expected_coeff_d === (expected_coeff_d ^ coeff_d ^ expected_coeff_d)) begin
                $display("PASS");
                $display("  Outputs: coeff_a=%h, coeff_d=%h",
                         coeff_a, coeff_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: coeff_a=%h, coeff_d=%h",
                         expected_coeff_a, expected_coeff_d);
                $display("  Got:      coeff_a=%h, coeff_d=%h",
                         coeff_a, coeff_d);
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
        $dumpvars(0,clk, rst, signal_in, coeff_a, coeff_d);
    end

endmodule
