`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] z_pos;
    reg [15:0] z_vel;
    wire [15:0] x_hat_pos;
    wire [15:0] x_hat_vel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .rst(rst),
        .z_pos(z_pos),
        .z_vel(z_vel),
        .x_hat_pos(x_hat_pos),
        .x_hat_vel(x_hat_vel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        z_pos = 16'h0000;
        z_vel = 16'h0000;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Zero Input and Reset Initialization", test_num);
        reset_dut();

        z_pos = 16'h0000;
        z_vel = 16'h0000;

        repeat(10) @(posedge clk);


        #1;



        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Static Convergence (Pos=1000, Vel=50)", test_num);
        reset_dut();

        z_pos = 16'd1000;
        z_vel = 16'd50;


        repeat(50) @(posedge clk);

        #1;


        check_outputs(16'd1000, 16'd50);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Large Value Stability", test_num);
        reset_dut();

        z_pos = 16'h7FFF;
        z_vel = 16'h00FF;

        repeat(100) @(posedge clk);

        #1;


        check_outputs(16'h7FFF, 16'h00FF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Negative Measurement Handling", test_num);
        reset_dut();

        z_pos = 16'hFF9C;
        z_vel = 16'hFFF6;

        repeat(50) @(posedge clk);

        #1;


        check_outputs(16'hFF9C, 16'hFFF6);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Dynamic Response to Step Change", test_num);
        reset_dut();


        z_pos = 16'd500;
        z_vel = 16'd10;
        repeat(40) @(posedge clk);


        z_pos = 16'd600;
        z_vel = 16'd20;


        repeat(60) @(posedge clk);

        #1;


        check_outputs(16'd600, 16'd20);
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
        input [15:0] expected_x_hat_pos;
        input [15:0] expected_x_hat_vel;
        begin
            if (expected_x_hat_pos === (expected_x_hat_pos ^ x_hat_pos ^ expected_x_hat_pos) &&
                expected_x_hat_vel === (expected_x_hat_vel ^ x_hat_vel ^ expected_x_hat_vel)) begin
                $display("PASS");
                $display("  Outputs: x_hat_pos=%h, x_hat_vel=%h",
                         x_hat_pos, x_hat_vel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_hat_pos=%h, x_hat_vel=%h",
                         expected_x_hat_pos, expected_x_hat_vel);
                $display("  Got:      x_hat_pos=%h, x_hat_vel=%h",
                         x_hat_pos, x_hat_vel);
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
        $dumpvars(0,clk, rst, z_pos, z_vel, x_hat_pos, x_hat_vel);
    end

endmodule
