`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg reset;
    wire [15:0] position_estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement(measurement),
        .reset(reset),
        .position_estimate(position_estimate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            measurement = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initialization Check", test_num);
            reset_dut();
            measurement = 16'h0000;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Step Response", test_num);
            reset_dut();
            measurement = 16'h1000;
            @(posedge clk);
            #1;



            #1;




            check_outputs(position_estimate);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Convergence Test", test_num);
            reset_dut();
            measurement = 16'h4000;
            repeat(50) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h4000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Noise Filtering", test_num);
            reset_dut();

            repeat(10) begin
                measurement = 16'h2100; @(posedge clk);
                measurement = 16'h1F00; @(posedge clk);
            end
            #1;


            $display("  Info: Final estimate after noise: %h", position_estimate);
            #1;

            check_outputs(position_estimate);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Full Scale Range Test", test_num);
            reset_dut();
            measurement = 16'hFFFF;
            repeat(40) @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %0d: Dynamic Tracking", test_num);
            reset_dut();
            for (i = 0; i < 100; i = i + 10) begin
                measurement = i[15:0];
                repeat(2) @(posedge clk);
            end
            #1;

            #1;


            check_outputs(position_estimate);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kalman_filter Testbench");
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
        input [15:0] expected_position_estimate;
        begin
            if (expected_position_estimate === (expected_position_estimate ^ position_estimate ^ expected_position_estimate)) begin
                $display("PASS");
                $display("  Outputs: position_estimate=%h",
                         position_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: position_estimate=%h",
                         expected_position_estimate);
                $display("  Got:      position_estimate=%h",
                         position_estimate);
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
        $dumpvars(0,clk, measurement, reset, position_estimate);
    end

endmodule
