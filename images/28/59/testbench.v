`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] K;
    reg clk;
    reg rst;
    reg [31:0] u;
    reg [31:0] z;
    wire [31:0] x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .K(K),
        .clk(clk),
        .rst(rst),
        .u(u),
        .z(z),
        .x(x)
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
            z = 0;
            K = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Pure Prediction (K=0)", test_num);
            reset_dut();
            u = 32'd15;
            K = 32'd0;
            z = 32'd100;
            @(posedge clk);
            #1 #1;
 check_outputs(32'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Pure Update (u=0, K=1)", test_num);
            reset_dut();
            u = 32'd0;
            K = 32'd1;
            z = 32'd50;
            @(posedge clk);
            #1 #1;
 check_outputs(32'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Combined Step (u=10, K=2, z=100)", test_num);
            reset_dut();
            u = 32'd10;
            K = 32'd2;
            z = 32'd100;
            @(posedge clk);
            #1 #1;
 check_outputs(32'd190);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Multi-cycle Accumulation", test_num);
            reset_dut();
            K = 32'd0;
            u = 32'd5;
            @(posedge clk);
            u = 32'd5;
            @(posedge clk);
            #1 #1;
 check_outputs(32'd10);
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
        input [31:0] expected_x;
        begin
            if (expected_x === (expected_x ^ x ^ expected_x)) begin
                $display("PASS");
                $display("  Outputs: x=%h",
                         x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x=%h",
                         expected_x);
                $display("  Got:      x=%h",
                         x);
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
        $dumpvars(0,K, clk, rst, u, z, x);
    end

endmodule
