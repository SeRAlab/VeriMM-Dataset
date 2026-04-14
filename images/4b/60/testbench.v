`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_en;
    reg clock;
    reg [31:0] dataa;
    reg [31:0] datab;
    wire overflow;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_en(clk_en),
        .clock(clock),
        .dataa(dataa),
        .datab(datab),
        .overflow(overflow),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            clk_en = 0;
            dataa = 32'h0;
            datab = 32'h0;
            @(posedge clock);
            #1;
            clk_en = 1;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: 1.0 + 1.0", test_num);
            dataa = 32'h3F800000;
            datab = 32'h3F800000;
            clk_en = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0, 32'h40000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: 1.0 + 0.5", test_num);
            dataa = 32'h3F800000;
            datab = 32'h3F000000;
            clk_en = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0, 32'h3FC00000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: 2.0 + (-1.0)", test_num);
            dataa = 32'h40000000;
            datab = 32'hBF800000;
            clk_en = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0, 32'h3F800000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: 1.0 + (-1.0)", test_num);
            dataa = 32'h3F800000;
            datab = 32'hBF800000;
            clk_en = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: Large exponent difference", test_num);
            dataa = 32'h44800000;
            datab = 32'h3D800000;
            clk_en = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0, 32'h44802000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %03d: Overflow check", test_num);
            dataa = 32'h7F7FFFFF;
            datab = 32'h7F7FFFFF;
            clk_en = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 32'h7F800000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Testcase %03d: Clock Enable check", test_num);


            dataa = 32'h3F800000;
            datab = 32'h3F800000;
            clk_en = 1;
            @(posedge clock);
            #2;


            clk_en = 0;
            dataa = 32'h40800000;
            datab = 32'h40800000;
            @(posedge clock);
            #2;

            #1;


            check_outputs(1'b0, 32'h40000000);
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
        input expected_overflow;
        input [31:0] expected_result;
        begin
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h",
                         overflow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h",
                         expected_overflow, expected_result);
                $display("  Got:      overflow=%b, result=%h",
                         overflow, result);
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
        $dumpvars(0,clk_en, clock, dataa, datab, overflow, result);
    end

endmodule
