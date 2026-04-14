`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_2b;
    reg resetn_2b;
    reg [31:0] source_number_2b_0;
    reg [1:0] source_number_2b_1;
    wire [63:0] result_2b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_2b(clk_2b),
        .resetn_2b(resetn_2b),
        .source_number_2b_0(source_number_2b_0),
        .source_number_2b_1(source_number_2b_1),
        .result_2b(result_2b)
    );

    // Clock generation (10ns period)
    initial begin
        clk_2b = 0;
        forever #5 clk_2b = ~clk_2b;
    end

        task reset_dut;

        begin
            resetn_2b = 0;
            source_number_2b_0 = 0;
            source_number_2b_1 = 0;
            @(posedge clk_2b);
            #2;
            resetn_2b = 1;
            @(posedge clk_2b);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selection 0", test_num);
            reset_dut();
            source_number_2b_0 = 32'h12345678;
            source_number_2b_1 = 2'b00;
            @(posedge clk_2b);
            #2;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selection 1 (Multiply by 1)", test_num);
            reset_dut();
            source_number_2b_0 = 32'hA5A5A5A5;
            source_number_2b_1 = 2'b01;
            @(posedge clk_2b);
            #2;
            #1;

            check_outputs({32'h0, 32'hA5A5A5A5});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selection 2 (Multiply by 2)", test_num);
            reset_dut();
            source_number_2b_0 = 32'd100;
            source_number_2b_1 = 2'b10;
            @(posedge clk_2b);
            #2;
            #1;

            check_outputs(64'd200);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selection 3 (Multiply by 3)", test_num);
            reset_dut();
            source_number_2b_0 = 32'd100;
            source_number_2b_1 = 2'b11;
            @(posedge clk_2b);
            #2;
            #1;

            check_outputs(64'd300);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large value selection 2", test_num);
            reset_dut();
            source_number_2b_0 = 32'hFFFFFFFF;
            source_number_2b_1 = 2'b10;
            @(posedge clk_2b);
            #2;

            #1;


            check_outputs(64'h1FFFFFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large value selection 3", test_num);
            reset_dut();
            source_number_2b_0 = 32'hFFFFFFFF;
            source_number_2b_1 = 2'b11;
            @(posedge clk_2b);
            #2;

            #1;


            check_outputs(64'h2FFFFFFFDu);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset dominance", test_num);
            reset_dut();
            source_number_2b_0 = 32'hFFFFFFFF;
            source_number_2b_1 = 2'b11;
            @(posedge clk_2b);
            #1;
            resetn_2b = 0;
            @(posedge clk_2b);
            #2;
            #1;

            check_outputs(64'h0);
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
        input [63:0] expected_result_2b;
        begin
            if (expected_result_2b === (expected_result_2b ^ result_2b ^ expected_result_2b)) begin
                $display("PASS");
                $display("  Outputs: result_2b=%h",
                         result_2b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result_2b=%h",
                         expected_result_2b);
                $display("  Got:      result_2b=%h",
                         result_2b);
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
        $dumpvars(0,clk_2b, resetn_2b, source_number_2b_0, source_number_2b_1, result_2b);
    end

endmodule
