`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg new_input;
    reg reset;
    wire output_sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .new_input(new_input),
        .reset(reset),
        .output_sum(output_sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            new_input = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            reset_dut();
            repeat(8) begin
                new_input = 0;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            reset_dut();
            repeat(8) begin
                new_input = 1;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Seven Ones", test_num);
            reset_dut();
            repeat(7) begin
                new_input = 1;
                @(posedge clk);
            end
            new_input = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Pattern", test_num);
            reset_dut();
            repeat(4) begin
                new_input = 1; @(posedge clk);
                new_input = 0; @(posedge clk);
            end
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting Window", test_num);
            reset_dut();

            repeat(8) begin
                new_input = 1;
                @(posedge clk);
            end


            new_input = 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Mid-Operation", test_num);
            reset_dut();
            repeat(4) begin
                new_input = 1;
                @(posedge clk);
            end

            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Three Ones", test_num);
            reset_dut();
            repeat(5) begin
                new_input = 0;
                @(posedge clk);
            end
            repeat(3) begin
                new_input = 1;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_output_sum;
        begin
            if (expected_output_sum === (expected_output_sum ^ output_sum ^ expected_output_sum)) begin
                $display("PASS");
                $display("  Outputs: output_sum=%b",
                         output_sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_sum=%b",
                         expected_output_sum);
                $display("  Got:      output_sum=%b",
                         output_sum);
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
        $dumpvars(0,clk, new_input, reset, output_sum);
    end

endmodule
