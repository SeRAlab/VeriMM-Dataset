`timescale 1ns/1ps

module cordic_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] angle;
    reg clk;
    reg rst;
    wire [15:0] cosine;
    wire ready;
    wire [15:0] sine;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cordic dut (
        .angle(angle),
        .clk(clk),
        .rst(rst),
        .cosine(cosine),
        .ready(ready),
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
            angle = 16'h0000;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Angle 0 rad", test_num);
            reset_dut();

            angle = 16'h0000;


            wait(ready == 1);
            @(posedge clk);


            #1;



            check_outputs(16'h7FFF, 1'b1, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Angle PI/4 rad (45 deg)", test_num);
            reset_dut();

            angle = 16'h1922;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(16'h5A82, 1'b1, 16'h5A82);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Angle PI/2 rad (90 deg)", test_num);
            reset_dut();

            angle = 16'h3244;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(16'h0000, 1'b1, 16'h7FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Angle -PI/4 rad (-45 deg)", test_num);
            reset_dut();

            angle = 16'hE6DE;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(16'h5A82, 1'b1, 16'hA57E);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Angle PI/6 rad (30 deg)", test_num);
            reset_dut();

            angle = 16'h10C1;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(16'h6EDA, 1'b1, 16'h4000);
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
        input [15:0] expected_cosine;
        input expected_ready;
        input [15:0] expected_sine;
        begin
            if (expected_cosine === (expected_cosine ^ cosine ^ expected_cosine) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_sine === (expected_sine ^ sine ^ expected_sine)) begin
                $display("PASS");
                $display("  Outputs: cosine=%h, ready=%b, sine=%h",
                         cosine, ready, sine);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cosine=%h, ready=%b, sine=%h",
                         expected_cosine, expected_ready, expected_sine);
                $display("  Got:      cosine=%h, ready=%b, sine=%h",
                         cosine, ready, sine);
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
        $dumpvars(0,angle, clk, rst, cosine, ready, sine);
    end

endmodule
