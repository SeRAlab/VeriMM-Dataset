`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] G;
    reg clk;
    reg reset;
    reg select;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .G(G),
        .clk(clk),
        .reset(reset),
        .select(select),
        .product(product)
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
            @(posedge clk);
            reset = 0;

            A = 0;
            B = 0;
            G = 0;
            select = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset", test_num);
            reset_dut();


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gray to Binary (G=4'b1100)", test_num);
            reset_dut();
            select = 0;
            G = 4'b1100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gray to Binary (G=4'b1111)", test_num);
            reset_dut();
            select = 0;
            G = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplier (3 * 4)", test_num);
            reset_dut();
            select = 1;
            A = 4'd3;
            B = 4'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0C);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplier (15 * 15)", test_num);
            reset_dut();
            select = 1;
            A = 4'd15;
            B = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hE1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select Switch Multiplier to Gray", test_num);
            reset_dut();

            select = 1;
            A = 4'd5;
            B = 4'd2;
            @(posedge clk);

            select = 0;
            G = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
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
        $dumpvars(0,A, B, G, clk, reset, select, product);
    end

endmodule
