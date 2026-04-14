`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task run_test;

        input [3:0] in_a;
        input [3:0] in_b;
        input [7:0] expected;
        begin
            test_num = test_num + 1;
            A = in_a;
            B = in_b;


            repeat (8) @(posedge clk);
            #2;
            $display("Test Case %0d: %d * %d", test_num, $signed(in_a), $signed(in_b));
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            run_test(4'd0, 4'd0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            run_test(4'd5, 4'd0, 8'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            run_test(4'd3, 4'd2, 8'd6);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            run_test(4'd7, 4'd7, 8'd49);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            run_test(4'd3, 4'b1110, 8'b11111010);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            run_test(4'b1100, 4'd2, 8'b11111000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            run_test(4'b1101, 4'b1110, 8'd6);
        end
        endtask

    task testcase008;

        begin
            reset_dut();

            run_test(4'b1000, 4'd1, 8'b11111000);
        end
        endtask

    task testcase009;

        begin
            reset_dut();

            run_test(4'b1000, 4'b1000, 8'h40);
        end
        endtask

    task testcase010;

        begin
            reset_dut();

            run_test(4'd7, 4'b1111, 8'b11111001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        begin
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
        $dumpvars(0,A, B, clk, product);
    end

endmodule
