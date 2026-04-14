`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] x_hat;
    reg [15:0] z;
    wire [15:0] K;
    wire [15:0] x_est;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .reset(reset),
        .x_hat(x_hat),
        .z(z),
        .K(K),
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
        x_hat = 0;
        z = 0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Measurement matches previous estimate", test_num);

        x_hat = 16'h0100;
        z     = 16'h0100;

        @(posedge clk);
        #2;


        #1;



        check_outputs(16'h0080, 16'h0100);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Measurement higher than estimate", test_num);

        x_hat = 16'h0200;
        z     = 16'h0400;

        @(posedge clk);
        #2;


        #1;



        check_outputs(16'h0080, 16'h0300);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Measurement lower than estimate", test_num);

        x_hat = 16'h0600;
        z     = 16'h0200;

        @(posedge clk);
        #2;


        #1;



        check_outputs(16'h0080, 16'h0400);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Large input values", test_num);

        x_hat = 16'h4000;
        z     = 16'h6000;

        @(posedge clk);
        #2;


        #1;



        check_outputs(16'h0080, 16'h5000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Zero inputs", test_num);

        x_hat = 16'h0000;
        z     = 16'h0000;

        @(posedge clk);
        #2;

        #1;


        check_outputs(16'h0080, 16'h0000);
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
        input [15:0] expected_K;
        input [15:0] expected_x_est;
        begin
            if (expected_K === (expected_K ^ K ^ expected_K) &&
                expected_x_est === (expected_x_est ^ x_est ^ expected_x_est)) begin
                $display("PASS");
                $display("  Outputs: K=%h, x_est=%h",
                         K, x_est);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: K=%h, x_est=%h",
                         expected_K, expected_x_est);
                $display("  Got:      K=%h, x_est=%h",
                         K, x_est);
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
        $dumpvars(0,clk, reset, x_hat, z, K, x_est);
    end

endmodule
