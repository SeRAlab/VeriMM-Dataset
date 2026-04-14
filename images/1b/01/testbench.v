`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] u;
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
        .clk(clk),
        .rst(rst),
        .u(u),
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
            rst = 1;
            u = 0;
            z1 = 0;
            z2 = 0;
            repeat(5) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Input Stability", test_num);
            reset_dut();
            u = 16'h0000;
            z1 = 16'h0000;
            z2 = 16'h0000;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Static Convergence", test_num);
            reset_dut();
            u = 16'h0000;
            z1 = 16'h1000;
            z2 = 16'h1000;

            repeat(20) @(posedge clk);


            #1;



            check_outputs(16'h00A0, 16'h1000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sensor Fusion Midpoint", test_num);
            reset_dut();
            u = 16'h0000;
            z1 = 16'h1000;
            z2 = 16'h2000;
            repeat(20) @(posedge clk);

            #1;


            check_outputs(16'h0080, 16'h1800);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Control Input (Predictive) Influence", test_num);
            reset_dut();
            u = 16'h0100;
            z1 = 16'h0500;
            z2 = 16'h0500;
            repeat(15) @(posedge clk);


            #1;



            check_outputs(16'h00C0, 16'h0600);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Step Change Response", test_num);
            reset_dut();

            u = 16'h0000;
            z1 = 16'h1000;
            z2 = 16'h1000;
            repeat(10) @(posedge clk);

            z1 = 16'h4000;
            z2 = 16'h4000;
            repeat(15) @(posedge clk);

            #1;


            check_outputs(16'h00A0, 16'h4000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High Uncertainty Tracking", test_num);
            reset_dut();
            u = 16'h0000;
            z1 = 16'hFFFF;
            z2 = 16'h0001;
            repeat(30) @(posedge clk);

            #1;


            check_outputs(16'h0100, 16'h8000);
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
        $dumpvars(0,clk, rst, u, z1, z2, p_est, x_est);
    end

endmodule
