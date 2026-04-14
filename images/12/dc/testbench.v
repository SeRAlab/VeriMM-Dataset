`timescale 1ns/1ps

module state_space_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg u;
    reg [1:0] x;
    wire [1:0] x_next;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    state_space_controller dut (
        .clk(clk),
        .rst(rst),
        .u(u),
        .x(x),
        .x_next(x_next),
        .y(y)
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
            x = 2'b00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();
            u = 0;
            x = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Impulse", test_num);
            reset_dut();
            u = 1;
            x = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State x[0] persistence", test_num);
            reset_dut();
            u = 0;
            x = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State x[1] decay/persistence", test_num);
            reset_dut();
            u = 0;
            x = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Combined State Influence", test_num);
            reset_dut();
            u = 0;
            x = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("state_space_controller Testbench");
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
        input [1:0] expected_x_next;
        input expected_y;
        begin
            if (expected_x_next === (expected_x_next ^ x_next ^ expected_x_next) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: x_next=%h, y=%b",
                         x_next, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_next=%h, y=%b",
                         expected_x_next, expected_y);
                $display("  Got:      x_next=%h, y=%b",
                         x_next, y);
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
        $dumpvars(0,clk, rst, u, x, x_next, y);
    end

endmodule
