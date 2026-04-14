`timescale 1ns/1ps

module adder_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg reset;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            a = 0;
            b = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            a = 8'd15;
            b = 8'd25;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Testcase %03d: Basic addition (15 + 25)", test_num);
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            a = 8'd0;
            b = 8'd0;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Testcase %03d: Zero addition (0 + 0)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            a = 8'd128;
            b = 8'd127;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Testcase %03d: Max result (128 + 127)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            a = 8'd255;
            b = 8'd1;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Testcase %03d: Overflow wrapping (255 + 1)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            a = 8'd200;
            b = 8'd100;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Testcase %03d: Large wrap-around (200 + 100)", test_num);
            #1;

            check_outputs(8'd44);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            a = 8'd50;
            b = 8'd50;

            reset = 1;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous reset check", test_num);
            #1;

            check_outputs(8'd0);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder Testbench");
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
        input [7:0] expected_sum;
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
        $dumpvars(0,a, b, clk, reset, sum);
    end

endmodule
