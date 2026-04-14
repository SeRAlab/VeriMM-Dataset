`timescale 1ns/1ps

module neural_neuron_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] b;
    reg clk;
    reg enable;
    reg [3:0] threshold;
    reg [3:0] w1;
    reg [3:0] w2;
    reg [3:0] w3;
    reg [3:0] w4;
    reg [3:0] w5;
    reg [3:0] x1;
    reg [3:0] x2;
    reg [3:0] x3;
    reg [3:0] x4;
    reg [3:0] x5;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neural_neuron dut (
        .b(b),
        .clk(clk),
        .enable(enable),
        .threshold(threshold),
        .w1(w1),
        .w2(w2),
        .w3(w3),
        .w4(w4),
        .w5(w5),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .x5(x5),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            b = 0;
            threshold = 0;
            w1 = 0; w2 = 0; w3 = 0; w4 = 0; w5 = 0;
            x1 = 0; x2 = 0; x3 = 0; x4 = 0; x5 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            x1 = 1; x2 = 1; x3 = 1; x4 = 1; x5 = 1;
            w1 = 2; w2 = 2; w3 = 2; w4 = 2; w5 = 2;
            b = 2;
            threshold = 10;
            enable = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            x1 = 1; x2 = 1; x3 = 1; x4 = 1; x5 = 1;
            w1 = 1; w2 = 1; w3 = 1; w4 = 1; w5 = 1;
            b = 0;
            threshold = 10;
            enable = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            x1 = 2; x2 = 2; x3 = 2; x4 = 2; x5 = 2;
            w1 = 1; w2 = 1; w3 = 1; w4 = 1; w5 = 1;
            b = 0;
            threshold = 10;
            enable = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;


            x1 = 2; w1 = 5; threshold = 5; enable = 1;
            @(posedge clk);
            #2;


            enable = 0;
            x1 = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;


            x1 = 1; x2 = 1; x3 = 1; x4 = 1; x5 = 1;
            w1 = 1; w2 = 1; w3 = 1; w4 = 1; w5 = 1;
            b = 3;
            threshold = 7;
            enable = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;

            x1 = 15; x2 = 15; x3 = 15; x4 = 15; x5 = 15;
            w1 = 15; w2 = 15; w3 = 15; w4 = 15; w5 = 15;
            b = 15;
            threshold = 15;
            enable = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("neural_neuron Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
        $dumpvars(0,b, clk, enable, threshold, w1, w2, w3, w4, w5, x1, x2, x3, x4, x5, y);
    end

endmodule
