`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] gradient_x;
    reg [3:0] gradient_y;
    reg rst;
    wire [3:0] position_x;
    wire [3:0] position_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .clk(clk),
        .gradient_x(gradient_x),
        .gradient_y(gradient_y),
        .rst(rst),
        .position_x(position_x),
        .position_y(position_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            gradient_x = 4'd0;
            gradient_y = 4'd0;
            @(posedge clk);
            #1;
            rst = 0;
            $display("DUT Reset performed.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Gradient", test_num);
            reset_dut();
            gradient_x = 4'b0000;
            gradient_y = 4'b0000;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Positive Gradient Update", test_num);
            reset_dut();
            gradient_x = 4'b0001;
            gradient_y = 4'b0010;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hF, 4'hE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative Gradient Update", test_num);
            reset_dut();
            gradient_x = 4'b1110;
            gradient_y = 4'b1111;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h2, 4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Multi-cycle Accumulation", test_num);
            reset_dut();
            gradient_x = 4'b0001;
            gradient_y = 4'b0001;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(4'hD, 4'hD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary Logic", test_num);
            reset_dut();
            gradient_x = 4'b0111;
            gradient_y = 4'b1000;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h9, 4'h8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gradient_descent Testbench");
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
        input [3:0] expected_position_x;
        input [3:0] expected_position_y;
        begin
            if (expected_position_x === (expected_position_x ^ position_x ^ expected_position_x) &&
                expected_position_y === (expected_position_y ^ position_y ^ expected_position_y)) begin
                $display("PASS");
                $display("  Outputs: position_x=%h, position_y=%h",
                         position_x, position_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: position_x=%h, position_y=%h",
                         expected_position_x, expected_position_y);
                $display("  Got:      position_x=%h, position_y=%h",
                         position_x, position_y);
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
        $dumpvars(0,clk, gradient_x, gradient_y, rst, position_x, position_y);
    end

endmodule
