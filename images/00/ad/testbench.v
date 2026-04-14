`timescale 1ns/1ps

module pipeline_arithmetic_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    wire [7:0] product;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_arithmetic dut (
        .a(a),
        .b(b),
        .clk(clk),
        .product(product),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;

            @(posedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic addition (2 + 3)", test_num);
            reset_dut();
            a = 4'd2;
            b = 4'd3;

            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd10, 4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Zero inputs (0 + 0)", test_num);
            reset_dut();
            a = 4'd0;
            b = 4'd0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max inputs (15 + 15)", test_num);
            reset_dut();
            a = 4'd15;
            b = 4'd15;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd28, 4'd14);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overflow result 16 (8 + 8)", test_num);
            reset_dut();
            a = 4'd8;
            b = 4'd8;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Medium values (7 + 5)", test_num);
            reset_dut();
            a = 4'd7;
            b = 4'd5;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd24, 4'd12);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_arithmetic Testbench");
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
        input [7:0] expected_product;
        input [3:0] expected_sum;
        begin
            if (expected_product === (expected_product ^ product ^ expected_product) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: product=%h, sum=%h",
                         product, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h, sum=%h",
                         expected_product, expected_sum);
                $display("  Got:      product=%h, sum=%h",
                         product, sum);
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
        $dumpvars(0,a, b, clk, product, sum);
    end

endmodule
