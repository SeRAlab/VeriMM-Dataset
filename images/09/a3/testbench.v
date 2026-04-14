`timescale 1ns/1ps

module pipelined_adder_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg rst;
    wire [8:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_adder dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 0;
            b = 0;
            @(posedge clk);
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition (5 + 10)", test_num);

            a = 8'd5;
            b = 8'd10;


            repeat (7) @(posedge clk);

            #1;
            #1;

            check_outputs(9'd15);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Maximum Values (255 + 255)", test_num);

            a = 8'hFF;
            b = 8'hFF;

            repeat (7) @(posedge clk);

            #1;
            #1;

            check_outputs(9'd510);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Zero Addition (0 + 0)", test_num);

            a = 8'd0;
            b = 8'd0;

            repeat (7) @(posedge clk);

            #1;
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Boundary Carry (128 + 128)", test_num);

            a = 8'd128;
            b = 8'd128;

            repeat (7) @(posedge clk);

            #1;
            #1;

            check_outputs(9'd256);
        end
        endtask

    task testcase005;

        reg [7:0] val_a;
        reg [7:0] val_b;
        begin
            reset_dut();
            test_num = test_num + 1;
            val_a = $urandom_range(0, 255);
            val_b = $urandom_range(0, 255);
            $display("Test %0d: Random Addition (%0d + %0d)", test_num, val_a, val_b);

            a = val_a;
            b = val_b;

            repeat (7) @(posedge clk);

            #1;
            #1;

            check_outputs(val_a + val_b);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_adder Testbench");
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
        input [8:0] expected_sum;
        begin
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
        $dumpvars(0,a, b, clk, rst, sum);
    end

endmodule
