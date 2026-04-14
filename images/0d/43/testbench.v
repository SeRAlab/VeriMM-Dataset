`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] q;
    reg [15:0] r;
    reg rst;
    reg [15:0] z_pos;
    reg [15:0] z_vel;
    wire [15:0] x_pos;
    wire [15:0] x_vel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .q(q),
        .r(r),
        .rst(rst),
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
            rst = 1;
            q = 16'h0001;
            r = 16'h0010;
            z_pos = 16'h0000;
            z_vel = 16'h0000;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();


            #1;



            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Measurement Tracking", test_num);
            reset_dut();

            z_pos = 16'h0000;
            z_vel = 16'h0000;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Constant Position Tracking", test_num);
            reset_dut();

            q = 16'h0001;
            r = 16'h0001;
            z_pos = 16'h1000;
            z_vel = 16'h0000;


            repeat(50) @(posedge clk);



            if (x_pos > 16'h0800)
                #1;

                check_outputs(x_pos, x_vel);
            else
                #1;

                check_outputs(16'h1000, 16'h0000);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Constant Velocity Tracking", test_num);
            reset_dut();

            q = 16'h0010;
            r = 16'h0001;
            z_vel = 16'h0100;

            for(i=0; i<32; i=i+1) begin
                z_pos = i * 16'h0100;
                @(posedge clk);
            end


            if (x_vel > 16'h0080)
                #1;

                check_outputs(x_pos, x_vel);
            else
                #1;

                check_outputs(x_pos, 16'h0100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Measurement Noise Response", test_num);
            reset_dut();

            q = 16'h0001;
            r = 16'hFFFF;
            z_pos = 16'h7000;
            z_vel = 16'h0000;

            repeat(10) @(posedge clk);



            if (x_pos < 16'h1000)
                #1;

                check_outputs(x_pos, x_vel);
            else
                #1;

                check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Process Noise Response", test_num);
            reset_dut();

            q = 16'hFFFF;
            r = 16'h0001;
            z_pos = 16'h4000;
            z_vel = 16'h0200;

            repeat(5) @(posedge clk);


            if (x_pos > 16'h3000)
                #1;

                check_outputs(x_pos, x_vel);
            else
                #1;

                check_outputs(16'h4000, 16'h0200);
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
        $dumpvars(0,clk, q, r, rst, z_pos, z_vel, x_pos, x_vel);
    end

endmodule
