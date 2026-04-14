`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] A;
    reg [15:0] H;
    reg [15:0] Q;
    reg [15:0] R;
    reg clk;
    reg reset;
    reg [15:0] z1;
    reg [15:0] z2;
    wire [15:0] p_est;
    wire [15:0] x_est;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .A(A),
        .H(H),
        .Q(Q),
        .R(R),
        .clk(clk),
        .reset(reset),
        .z1(z1),
        .z2(z2),
        .p_est(p_est),
        .x_est(x_est)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            A = 16'h0000;
            H = 16'h0000;
            Q = 16'h0000;
            R = 16'h0000;
            z1 = 16'h0000;
            z2 = 16'h0000;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase 001: Basic Convergence");
            reset_dut();

            A = 16'h0001;
            H = 16'h0001;
            Q = 16'h0001;
            R = 16'h0001;
            z1 = 16'h0064;
            z2 = 16'h0064;


            repeat(10) @(posedge clk);



            #1;




            check_outputs(16'h0001, 16'h0063);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase 002: Zero State Stability");
            reset_dut();
            A = 16'h0001;
            H = 16'h0001;
            Q = 16'h0000;
            R = 16'h0001;
            z1 = 16'h0000;
            z2 = 16'h0000;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase 003: Sensor Fusion Discrepancy");
            reset_dut();
            A = 16'h0001;
            H = 16'h0001;
            Q = 16'h0002;
            R = 16'h0002;
            z1 = 16'h0010;
            z2 = 16'h0030;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(16'h0002, 16'h0020);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase 004: High Measurement Noise");
            reset_dut();
            A = 16'h0001;
            H = 16'h0001;
            Q = 16'h0001;
            R = 16'hFFFF;
            z1 = 16'h03E8;
            z2 = 16'h03E8;

            repeat(5) @(posedge clk);



            if (x_est < 16'h0050) begin
                pass_count = pass_count + 1;
                $display("PASS: Sluggish response as expected. x_est=%h", x_est);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Response too fast for high noise R. x_est=%h", x_est);
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning Testcase 005: High Process Noise");
            reset_dut();
            A = 16'h0001;
            H = 16'h0001;
            Q = 16'h00FF;
            R = 16'h0001;
            z1 = 16'h00C8;
            z2 = 16'h00C8;

            repeat(2) @(posedge clk);


            if (x_est > 16'h00A0) begin
                pass_count = pass_count + 1;
                $display("PASS: Fast response as expected. x_est=%h", x_est);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Response too slow for high noise Q. x_est=%h", x_est);
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
        $display("kalman_filter Testbench");
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
        input [15:0] expected_p_est;
        input [15:0] expected_x_est;
        begin
            if (expected_p_est === (expected_p_est ^ p_est ^ expected_p_est) &&
                expected_x_est === (expected_x_est ^ x_est ^ expected_x_est)) begin
                $display("PASS");
                $display("  Outputs: p_est=%h, x_est=%h",
                         p_est, x_est);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p_est=%h, x_est=%h",
                         expected_p_est, expected_x_est);
                $display("  Got:      p_est=%h, x_est=%h",
                         p_est, x_est);
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
        $dumpvars(0,A, H, Q, R, clk, reset, z1, z2, p_est, x_est);
    end

endmodule
