`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_1;
    reg pulse;
    reg reset;
    wire [11:0] mileage;
    wire [11:0] number_of_halfkm;
    wire work;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_1(clk_1),
        .pulse(pulse),
        .reset(reset),
        .mileage(mileage),
        .number_of_halfkm(number_of_halfkm),
        .work(work)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            pulse = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task send_pulses;

        input integer count;
        integer i;
        begin
            for (i = 0; i < count; i = i + 1) begin
                pulse = 1;
                @(posedge clk);
                pulse = 0;
                repeat(2) @(posedge clk);
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial Reset State", test_num);
            reset_dut();
            repeat(5) @(posedge clk);

            #1;


            check_outputs(12'd0, 12'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Applying 10 Pulses", test_num);
            reset_dut();
            send_pulses(10);
            repeat(10) @(posedge clk);

            #1;


            check_outputs(12'd10, 12'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reaching 500 Pulses (0.5 km)", test_num);
            reset_dut();
            send_pulses(500);
            repeat(10) @(posedge clk);

            #1;


            check_outputs(12'd500, 12'd1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reaching 1000 Pulses (1.0 km)", test_num);
            reset_dut();
            send_pulses(1000);
            repeat(10) @(posedge clk);

            #1;


            check_outputs(12'd1000, 12'd2, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Mid-Operation", test_num);
            reset_dut();
            send_pulses(100);
            reset = 1;
            repeat(2) @(posedge clk);
            reset = 0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(12'd0, 12'd0, 1'b0);
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
        input [11:0] expected_mileage;
        input [11:0] expected_number_of_halfkm;
        input expected_work;
        begin
            if (expected_mileage === (expected_mileage ^ mileage ^ expected_mileage) &&
                expected_number_of_halfkm === (expected_number_of_halfkm ^ number_of_halfkm ^ expected_number_of_halfkm) &&
                expected_work === (expected_work ^ work ^ expected_work)) begin
                $display("PASS");
                $display("  Outputs: mileage=%h, number_of_halfkm=%h, work=%b",
                         mileage, number_of_halfkm, work);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mileage=%h, number_of_halfkm=%h, work=%b",
                         expected_mileage, expected_number_of_halfkm, expected_work);
                $display("  Got:      mileage=%h, number_of_halfkm=%h, work=%b",
                         mileage, number_of_halfkm, work);
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
        $dumpvars(0,clk, clk_1, pulse, reset, mileage, number_of_halfkm, work);
    end

endmodule
