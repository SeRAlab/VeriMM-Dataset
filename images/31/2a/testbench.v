`timescale 1ns/1ps

module slam_robot_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] vx_in;
    reg [15:0] vy_in;
    reg [15:0] x_in;
    reg [15:0] y_in;
    wire [15:0] x_out;
    wire [15:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_robot dut (
        .clk(clk),
        .reset(reset),
        .vx_in(vx_in),
        .vy_in(vy_in),
        .x_in(x_in),
        .y_in(y_in),
        .x_out(x_out),
        .y_out(y_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Static position (Zero velocity)", test_num);

            x_in = 16'h000A;
            y_in = 16'h0014;
            vx_in = 16'h0000;
            vy_in = 16'h0000;

            reset_dut();


            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(16'h000A, 16'h0014);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Constant positive velocity", test_num);
            x_in = 16'h0000;
            y_in = 16'h0000;
            vx_in = 16'h0005;
            vy_in = 16'h0002;

            reset_dut();


            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(16'd50, 16'd20);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Constant negative velocity", test_num);
            x_in = 16'd1000;
            y_in = 16'd1000;
            vx_in = 16'hFFFB;
            vy_in = 16'hFFF6;

            reset_dut();




            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h03B6, 16'h0384);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dynamic velocity change during movement", test_num);
            x_in = 16'h0000;
            y_in = 16'h0000;
            vx_in = 16'h0001;
            vy_in = 16'h0001;

            reset_dut();


            repeat(5) @(posedge clk);
            #1;


            vx_in = 16'd10;
            vy_in = 16'd20;


            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(16'd25, 16'd45);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam_robot Testbench");
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
        input [15:0] expected_x_out;
        input [15:0] expected_y_out;
        begin
            if (expected_x_out === (expected_x_out ^ x_out ^ expected_x_out) &&
                expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: x_out=%h, y_out=%h",
                         x_out, y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_out=%h, y_out=%h",
                         expected_x_out, expected_y_out);
                $display("  Got:      x_out=%h, y_out=%h",
                         x_out, y_out);
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
        $dumpvars(0,clk, reset, vx_in, vy_in, x_in, y_in, x_out, y_out);
    end

endmodule
