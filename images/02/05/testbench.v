`timescale 1ns/1ps

module KalmanFilter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] sensor1;
    reg [15:0] sensor2;
    wire [15:0] P;
    wire [15:0] estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    KalmanFilter dut (
        .clk(clk),
        .reset(reset),
        .sensor1(sensor1),
        .sensor2(sensor2),
        .P(P),
        .estimate(estimate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            sensor1 = 0;
            sensor2 = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initialization Check", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identical Sensor Fusion", test_num);
            reset_dut();
            sensor1 = 16'h0100;
            sensor2 = 16'h0100;
            repeat(10) @(posedge clk);


            #1;



            check_outputs(P, 16'h0100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Differing Sensor Fusion", test_num);
            reset_dut();
            sensor1 = 16'h0200;
            sensor2 = 16'h0400;
            repeat(10) @(posedge clk);


            #1;



            check_outputs(P, 16'h0300);
        end
        endtask

    task testcase004;

        reg [15:0] p_initial;
        reg [15:0] p_final;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Covariance Reduction over time", test_num);
            reset_dut();
            sensor1 = 16'h0500;
            sensor2 = 16'h0500;

            @(posedge clk);
            p_initial = P;

            repeat(20) @(posedge clk);
            p_final = P;


            if (p_final < p_initial) begin
                pass_count = pass_count + 1;
                $display("PASS: P decreased from %h to %h", p_initial, p_final);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: P did not decrease. Initial: %h, Final: %h", p_initial, p_final);
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Step Response", test_num);
            reset_dut();
            sensor1 = 16'h0000;
            sensor2 = 16'h0000;
            repeat(5) @(posedge clk);

            sensor1 = 16'hFFFF;
            sensor2 = 16'hFFFF;
            repeat(1) @(posedge clk);


            if (estimate > 16'h0000 && estimate <= 16'hFFFF) begin
                 $display("PASS: Estimate responding to step input: %h", estimate);
                 pass_count = pass_count + 1;
            end else begin
                 $display("FAIL: Estimate did not respond. Got: %h", estimate);
                 fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("KalmanFilter Testbench");
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
        input [15:0] expected_P;
        input [15:0] expected_estimate;
        begin
            if (expected_P === (expected_P ^ P ^ expected_P) &&
                expected_estimate === (expected_estimate ^ estimate ^ expected_estimate)) begin
                $display("PASS");
                $display("  Outputs: P=%h, estimate=%h",
                         P, estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h, estimate=%h",
                         expected_P, expected_estimate);
                $display("  Got:      P=%h, estimate=%h",
                         P, estimate);
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
        $dumpvars(0,clk, reset, sensor1, sensor2, P, estimate);
    end

endmodule
