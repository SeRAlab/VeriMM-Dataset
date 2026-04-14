`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [21:0] adr_i;
    reg clk;
    reg invalidate;
    reg rst;
    reg validate;
    wire adr_valid;
    wire cache_hit;
    wire [21:0] cached_adr_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adr_i(adr_i),
        .clk(clk),
        .invalidate(invalidate),
        .rst(rst),
        .validate(validate),
        .adr_valid(adr_valid),
        .cache_hit(cache_hit),
        .cached_adr_o(cached_adr_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            adr_i = 0;
            validate = 0;
            invalidate = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: System Reset");
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(1'b0, 1'b0, 22'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Validation");
            test_num = 2;
            reset_dut();
            adr_i = 22'h1A2B3C;
            validate = 1;
            @(posedge clk);
            #1;
            validate = 0;


            #1;



            check_outputs(1'b1, 1'b1, 22'h1A2B3C);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Cache Miss");
            test_num = 3;
            reset_dut();
            adr_i = 22'h000AAA;
            validate = 1;
            @(posedge clk);
            #1;
            validate = 0;
            adr_i = 22'h000BBB;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 22'h000AAA);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Invalidation");
            test_num = 4;
            reset_dut();
            adr_i = 22'hFFFFFF;
            validate = 1;
            @(posedge clk);
            #1;
            validate = 0;
            invalidate = 1;
            @(posedge clk);
            #1;
            invalidate = 0;

            #1;


            check_outputs(1'b0, 1'b0, 22'hFFFFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Address Overwrite");
            test_num = 5;
            reset_dut();
            adr_i = 22'h111111;
            validate = 1;
            @(posedge clk);
            #1;
            adr_i = 22'h222222;
            validate = 1;
            @(posedge clk);
            #1;
            validate = 0;
            #1;

            check_outputs(1'b1, 1'b1, 22'h222222);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Invalidate during miss");
            test_num = 6;
            reset_dut();
            adr_i = 22'hCAFE01;
            validate = 1;
            @(posedge clk);
            #1;
            validate = 0;
            adr_i = 22'hBEEF02;
            invalidate = 1;
            @(posedge clk);
            #1;
            invalidate = 0;
            #1;

            check_outputs(1'b0, 1'b0, 22'hCAFE01);
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
        input expected_adr_valid;
        input expected_cache_hit;
        input [21:0] expected_cached_adr_o;
        begin
            if (expected_adr_valid === (expected_adr_valid ^ adr_valid ^ expected_adr_valid) &&
                expected_cache_hit === (expected_cache_hit ^ cache_hit ^ expected_cache_hit) &&
                expected_cached_adr_o === (expected_cached_adr_o ^ cached_adr_o ^ expected_cached_adr_o)) begin
                $display("PASS");
                $display("  Outputs: adr_valid=%b, cache_hit=%b, cached_adr_o=%h",
                         adr_valid, cache_hit, cached_adr_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adr_valid=%b, cache_hit=%b, cached_adr_o=%h",
                         expected_adr_valid, expected_cache_hit, expected_cached_adr_o);
                $display("  Got:      adr_valid=%b, cache_hit=%b, cached_adr_o=%h",
                         adr_valid, cache_hit, cached_adr_o);
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
        $dumpvars(0,adr_i, clk, invalidate, rst, validate, adr_valid, cache_hit, cached_adr_o);
    end

endmodule
