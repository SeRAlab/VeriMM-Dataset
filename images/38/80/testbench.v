`timescale 1ns/1ps

module cordic_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] angle;
    reg clk;
    reg rst;
    reg start;
    wire [31:0] cosine;
    wire done;
    wire [31:0] sine;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cordic dut (
        .angle(angle),
        .clk(clk),
        .rst(rst),
        .start(start),
        .cosine(cosine),
        .done(done),
        .sine(sine)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            angle = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task run_cordic;

        input [31:0] input_angle;
        begin
            angle = input_angle;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1'b1);

            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            $display("\nTestcase 001: Angle = 0 rad");
            test_num = test_num + 1;
            reset_dut();
            run_cordic(32'h00000000);
            #1;

            check_outputs(32'h40000000, 1'b1, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Angle = PI/4 rad");
            test_num = test_num + 1;
            reset_dut();
            run_cordic(32'h3243F6A8);
            #1;

            check_outputs(32'h2D413CCD, 1'b1, 32'h2D413CCD);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Angle = PI/2 rad");
            test_num = test_num + 1;
            reset_dut();
            run_cordic(32'h6487ED51);
            #1;

            check_outputs(32'h00000000, 1'b1, 32'h40000000);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Angle = -PI/4 rad");
            test_num = test_num + 1;
            reset_dut();
            run_cordic(32'hCDB60958);
            #1;

            check_outputs(32'h2D413CCD, 1'b1, 32'hD2BEC333);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Angle = PI/6 rad");
            test_num = test_num + 1;
            reset_dut();
            run_cordic(32'h2182AD6F);
            #1;

            check_outputs(32'h376CF533, 1'b1, 32'h20000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cordic Testbench");
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
        input [31:0] expected_cosine;
        input expected_done;
        input [31:0] expected_sine;
        begin
            if (expected_cosine === (expected_cosine ^ cosine ^ expected_cosine) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_sine === (expected_sine ^ sine ^ expected_sine)) begin
                $display("PASS");
                $display("  Outputs: cosine=%h, done=%b, sine=%h",
                         cosine, done, sine);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cosine=%h, done=%b, sine=%h",
                         expected_cosine, expected_done, expected_sine);
                $display("  Got:      cosine=%h, done=%b, sine=%h",
                         cosine, done, sine);
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
        $dumpvars(0,angle, clk, rst, start, cosine, done, sine);
    end

endmodule
