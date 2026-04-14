`timescale 1ns/1ps

module cordic_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] angle;
    reg clk;
    reg reset;
    reg start;
    wire [3:0] cosine;
    wire done;
    wire [3:0] sine;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cordic dut (
        .angle(angle),
        .clk(clk),
        .reset(reset),
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
            reset = 1;
            start = 0;
            angle = 4'b0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Angle = 0");
            reset_dut();
            test_num = 1;
            angle = 4'd0;
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done);
            @(posedge clk);
            #1;

            check_outputs(4'd15, 1'b1, 4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Angle = 0.25 rad (4/16)");
            reset_dut();
            test_num = 2;
            angle = 4'd4;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(4'd15, 1'b1, 4'd4);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Angle = 0.5 rad (8/16)");
            reset_dut();
            test_num = 3;
            angle = 4'd8;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(4'd14, 1'b1, 4'd8);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Angle = 0.75 rad (12/16)");
            reset_dut();
            test_num = 4;
            angle = 4'd12;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(4'd12, 1'b1, 4'd11);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Angle = 0.9375 rad (15/16)");
            reset_dut();
            test_num = 5;
            angle = 4'd15;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(4'd9, 1'b1, 4'd13);
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
        input [3:0] expected_cosine;
        input expected_done;
        input [3:0] expected_sine;
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
        $dumpvars(0,angle, clk, reset, start, cosine, done, sine);
    end

endmodule
