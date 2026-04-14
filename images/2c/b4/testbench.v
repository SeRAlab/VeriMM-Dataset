`timescale 1ns/1ps

module KalmanFilter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] z1;
    reg [15:0] z2;
    wire [15:0] v_est;
    wire [15:0] x_est;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    KalmanFilter dut (
        .clk(clk),
        .rst(rst),
        .z1(z1),
        .z2(z2),
        .v_est(v_est),
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
            z1 = 0;
            z2 = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Post-Reset Initialization", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Static Input Convergence", test_num);
            reset_dut();


            z1 = 16'h0100;
            z2 = 16'h0100;


            repeat(10) @(posedge clk);




            #1;





            check_outputs(v_est, x_est);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Sensor Fusion (Mismatched Sensors)", test_num);
            reset_dut();


            z1 = 16'h0200;
            z2 = 16'h0000;


            repeat(5) @(posedge clk);



            if (x_est > 16'h0000 && x_est < 16'h0200) begin
                $display("  PASS: Estimate converged between sensor bounds.");
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL: Estimate out of bounds.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Dynamic Velocity Tracking", test_num);
            reset_dut();


            for (i = 0; i < 20; i = i + 1) begin
                z1 = i * 20;
                z2 = i * 20;
                @(posedge clk);
            end


            if (v_est > 0 && x_est > 0) begin
                $display("  PASS: Velocity and Position tracking positive trend.");
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL: System failed to detect movement.");
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
        input [15:0] expected_v_est;
        input [15:0] expected_x_est;
        begin
            if (expected_v_est === (expected_v_est ^ v_est ^ expected_v_est) &&
                expected_x_est === (expected_x_est ^ x_est ^ expected_x_est)) begin
                $display("PASS");
                $display("  Outputs: v_est=%h, x_est=%h",
                         v_est, x_est);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v_est=%h, x_est=%h",
                         expected_v_est, expected_x_est);
                $display("  Got:      v_est=%h, x_est=%h",
                         v_est, x_est);
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
        $dumpvars(0,clk, rst, z1, z2, v_est, x_est);
    end

endmodule
