`timescale 1ns/1ps

module KalmanFilter_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] R_pos;
    reg [15:0] R_vel;
    reg clk;
    reg reset;
    reg [15:0] x_prev_pos;
    reg [15:0] x_prev_vel;
    reg [15:0] z_pos;
    reg [15:0] z_vel;
    wire [15:0] x_pos;
    wire [15:0] x_vel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    KalmanFilter dut (
        .R_pos(R_pos),
        .R_vel(R_vel),
        .clk(clk),
        .reset(reset),
        .x_prev_pos(x_prev_pos),
        .x_prev_vel(x_prev_vel),
        .z_pos(z_pos),
        .z_vel(z_vel),
        .x_pos(x_pos),
        .x_vel(x_vel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            R_pos = 0;
            R_vel = 0;
            x_prev_pos = 0;
            x_prev_vel = 0;
            z_pos = 0;
            z_vel = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Measurement equals previous state", test_num);

            x_prev_pos = 16'h1000;
            x_prev_vel = 16'h0500;
            z_pos = 16'h1000;
            z_vel = 16'h0500;
            R_pos = 16'h00FF;
            R_vel = 16'h00FF;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h1000, 16'h0500);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Low measurement noise (Trust sensor)", test_num);

            x_prev_pos = 16'h1000;
            x_prev_vel = 16'h0100;
            z_pos      = 16'h2000;
            z_vel      = 16'h0200;
            R_pos      = 16'h0001;
            R_vel      = 16'h0001;

            repeat(2) @(posedge clk);



            #1;




            check_outputs(16'h2000, 16'h0200);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: High measurement noise (Trust model)", test_num);

            x_prev_pos = 16'h4000;
            x_prev_vel = 16'h0A00;
            z_pos      = 16'hFFFF;
            z_vel      = 16'hFFFF;
            R_pos      = 16'hFFFF;
            R_vel      = 16'hFFFF;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(16'h4000, 16'h0A00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Mid-range noise (Balanced weighting)", test_num);

            x_prev_pos = 16'h1000;
            x_prev_vel = 16'h0200;
            z_pos      = 16'h2000;
            z_vel      = 16'h0400;



            R_pos      = 16'h0100;
            R_vel      = 16'h0100;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(16'h1800, 16'h0300);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Zero inputs", test_num);

            x_prev_pos = 0;
            x_prev_vel = 0;
            z_pos      = 0;
            z_vel      = 0;
            R_pos      = 16'h0100;
            R_vel      = 16'h0100;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0000, 16'h0000);
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
        input [15:0] expected_x_pos;
        input [15:0] expected_x_vel;
        begin
            if (expected_x_pos === (expected_x_pos ^ x_pos ^ expected_x_pos) &&
                expected_x_vel === (expected_x_vel ^ x_vel ^ expected_x_vel)) begin
                $display("PASS");
                $display("  Outputs: x_pos=%h, x_vel=%h",
                         x_pos, x_vel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_pos=%h, x_vel=%h",
                         expected_x_pos, expected_x_vel);
                $display("  Got:      x_pos=%h, x_vel=%h",
                         x_pos, x_vel);
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
        $dumpvars(0,R_pos, R_vel, clk, reset, x_prev_pos, x_prev_vel, z_pos, z_vel, x_pos, x_vel);
    end

endmodule
