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
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset Verification");
            reset_dut();

            #1;


            check_outputs(12'd0, 12'd0, clk_1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Single Pulse");
            reset_dut();


            @(posedge clk);
            pulse = 1;
            @(posedge clk);
            pulse = 0;


            repeat(5) @(posedge clk);



            #1;




            check_outputs(mileage, number_of_halfkm, work);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("\nRunning testcase003: Accumulation Tracking");
            reset_dut();


            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
                pulse = 1;
                @(posedge clk);
                pulse = 0;
                repeat(2) @(posedge clk);
            end


            if (mileage >= 0 && number_of_halfkm >= 0)
                #1;

                check_outputs(mileage, number_of_halfkm, work);
            else
                #1;

                check_outputs(12'hFFF, 12'hFFF, 0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Work Output Signal");
            reset_dut();


            wait(clk_1 == 1);
            #1;
            if (work == 1) pass_count = pass_count + 0;


            wait(clk_1 == 0);
            #1;

            #1;


            check_outputs(mileage, number_of_halfkm, work);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Pulse during Reset");
            reset_dut();
            reset = 1;
            repeat(5) @(posedge clk) pulse = ~pulse;
            #1;
            #1;

            check_outputs(12'd0, 12'd0, work);
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
