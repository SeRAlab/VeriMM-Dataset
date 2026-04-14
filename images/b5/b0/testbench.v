`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ldcand;
    reg ldencounter;
    reg ldlier;
    reg ldp;
    reg ldrstcounter;
    reg ldshift;
    reg ldsum;
    reg [31:0] multiplicand;
    reg [31:0] multiplier;
    wire [5:0] counter;
    wire [63:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ldcand(ldcand),
        .ldencounter(ldencounter),
        .ldlier(ldlier),
        .ldp(ldp),
        .ldrstcounter(ldrstcounter),
        .ldshift(ldshift),
        .ldsum(ldsum),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .counter(counter),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ldcand = 0;
            ldencounter = 0;
            ldlier = 0;
            ldp = 0;
            ldrstcounter = 1;
            ldshift = 0;
            ldsum = 0;
            multiplicand = 0;
            multiplier = 0;
            @(posedge clk);
            #1 ldrstcounter = 0;
        end
        endtask
    task perform_multiplication;

        input [31:0] a;
        input [31:0] b;
        integer i;
        begin

            multiplicand = a;
            multiplier = b;
            ldrstcounter = 1;
            ldcand = 1;
            ldlier = 1;
            ldp = 1;
            ldencounter = 0;
            ldshift = 0;
            ldsum = 0;
            @(posedge clk);
            #1;


            ldrstcounter = 0;
            ldcand = 0;
            ldlier = 0;
            ldp = 0;


            for (i = 0; i < 32; i = i + 1) begin

                if (product[0] == 1'b1) begin
                    ldsum = 1;
                    @(posedge clk);
                    #1;
                    ldsum = 0;
                end


                ldshift = 1;
                ldencounter = 1;
                @(posedge clk);
                #1;
                ldshift = 0;
                ldencounter = 0;
            end
        end
        endtask

    task testcase001;

        begin
            $display("Test Case 001: 7 * 3");
            test_num = 1;
            reset_dut();
            perform_multiplication(32'd7, 32'd3);
            #1;

            check_outputs(6'd32, 64'd21);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: 12345 * 0");
            test_num = 2;
            reset_dut();
            perform_multiplication(32'd12345, 32'd0);
            #1;

            check_outputs(6'd32, 64'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: 1000 * 2000");
            test_num = 3;
            reset_dut();
            perform_multiplication(32'd1000, 32'd2000);
            #1;

            check_outputs(6'd32, 64'd2000000);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: 0xFFFFFFFF * 2");
            test_num = 4;
            reset_dut();
            perform_multiplication(32'hFFFFFFFF, 32'd2);
            #1;

            check_outputs(6'd32, 64'h1FFFFFFFE);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: 1024 * 1024");
            test_num = 5;
            reset_dut();
            perform_multiplication(32'd1024, 32'd1024);
            #1;

            check_outputs(6'd32, 64'd1048576);
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
        input [5:0] expected_counter;
        input [63:0] expected_product;
        begin
            if (expected_counter === (expected_counter ^ counter ^ expected_counter) &&
                expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: counter=%h, product=%h",
                         counter, product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter=%h, product=%h",
                         expected_counter, expected_product);
                $display("  Got:      counter=%h, product=%h",
                         counter, product);
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
        $dumpvars(0,clk, ldcand, ldencounter, ldlier, ldp, ldrstcounter, ldshift, ldsum, multiplicand, multiplier, counter, product);
    end

endmodule
