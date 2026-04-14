`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] r1;
    reg [15:0] r2;
    reg rst;
    reg [15:0] z1;
    reg [15:0] z2;
    wire [15:0] r_fused;
    wire [15:0] z_fused;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .r1(r1),
        .r2(r2),
        .rst(rst),
        .z1(z1),
        .z2(z2),
        .r_fused(r_fused),
        .z_fused(z_fused)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            z1 = 16'h0;
            r1 = 16'h0;
            z2 = 16'h0;
            r2 = 16'h0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identical measurements and uncertainties", test_num);
            reset_dut();
            z1 = 16'd100; r1 = 16'd20;
            z2 = 16'd100; r2 = 16'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd10, 16'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Different measurements, identical uncertainties", test_num);
            reset_dut();
            z1 = 16'd100; r1 = 16'd40;
            z2 = 16'd200; r2 = 16'd40;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd20, 16'd150);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sensor 1 high confidence", test_num);
            reset_dut();
            z1 = 16'd100; r1 = 16'd10;
            z2 = 16'd200; r2 = 16'd90;
            @(posedge clk);
            #1;



            #1;




            check_outputs(16'd9, 16'd110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sensor 2 high confidence", test_num);
            reset_dut();
            z1 = 16'd100; r1 = 16'd90;
            z2 = 16'd200; r2 = 16'd10;
            @(posedge clk);
            #1;



            #1;




            check_outputs(16'd9, 16'd190);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 40/60 Uncertainty split", test_num);
            reset_dut();
            z1 = 16'd500; r1 = 16'd200;
            z2 = 16'd800; r2 = 16'd300;
            @(posedge clk);
            #1;



            #1;




            check_outputs(16'd120, 16'd620);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High uncertainty values", test_num);
            reset_dut();
            z1 = 16'd1000; r1 = 16'd400;
            z2 = 16'd1500; r2 = 16'd100;
            @(posedge clk);
            #1;



            #1;




            check_outputs(16'd80, 16'd1400);
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
        input [15:0] expected_r_fused;
        input [15:0] expected_z_fused;
        begin
            if (expected_r_fused === (expected_r_fused ^ r_fused ^ expected_r_fused) &&
                expected_z_fused === (expected_z_fused ^ z_fused ^ expected_z_fused)) begin
                $display("PASS");
                $display("  Outputs: r_fused=%h, z_fused=%h",
                         r_fused, z_fused);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r_fused=%h, z_fused=%h",
                         expected_r_fused, expected_z_fused);
                $display("  Got:      r_fused=%h, z_fused=%h",
                         r_fused, z_fused);
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
        $dumpvars(0,clk, r1, r2, rst, z1, z2, r_fused, z_fused);
    end

endmodule
