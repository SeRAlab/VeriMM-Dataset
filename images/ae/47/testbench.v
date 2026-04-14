`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg write_address_pass;
    reg write_data_pass;
    wire [31:0] instruction_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .write_address_pass(write_address_pass),
        .write_data_pass(write_data_pass),
        .instruction_count(instruction_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            write_address_pass = 0;
            write_data_pass = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            write_address_pass = 1;
            write_data_pass = 1;
            @(posedge clk);
            write_address_pass = 0;
            write_data_pass = 0;
            @(posedge clk);
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();
            @(posedge clk);
            write_address_pass = 1;
            write_data_pass = 1;
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
            end
            write_address_pass = 0;
            write_data_pass = 0;
            @(posedge clk);
            #1;

            check_outputs(32'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk);
            write_address_pass = 1;
            write_data_pass = 0;
            @(posedge clk);
            @(posedge clk);
            write_address_pass = 0;
            @(posedge clk);
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);
            write_address_pass = 0;
            write_data_pass = 1;
            @(posedge clk);
            @(posedge clk);
            write_data_pass = 0;
            @(posedge clk);
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(posedge clk);

            write_address_pass = 1; write_data_pass = 1;
            @(posedge clk);

            write_address_pass = 0; write_data_pass = 1;
            @(posedge clk);

            write_address_pass = 1; write_data_pass = 0;
            @(posedge clk);

            write_address_pass = 1; write_data_pass = 1;
            @(posedge clk);
            write_address_pass = 0; write_data_pass = 0;
            @(posedge clk);
            #1;

            check_outputs(32'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            @(posedge clk);
            write_address_pass = 1;
            write_data_pass = 1;
            repeat(5) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            write_address_pass = 0;
            write_data_pass = 0;
            @(posedge clk);
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = 8;
            reset_dut();
            @(posedge clk);
            write_address_pass = 1;
            write_data_pass = 1;
            for (i = 0; i < 100; i = i + 1) begin
                @(posedge clk);
            end
            write_address_pass = 0;
            write_data_pass = 0;
            @(posedge clk);
            #1;

            check_outputs(32'd100);
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
        input [31:0] expected_instruction_count;
        begin
            if (expected_instruction_count === (expected_instruction_count ^ instruction_count ^ expected_instruction_count)) begin
                $display("PASS");
                $display("  Outputs: instruction_count=%h",
                         instruction_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instruction_count=%h",
                         expected_instruction_count);
                $display("  Got:      instruction_count=%h",
                         instruction_count);
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
        $dumpvars(0,clk, reset, write_address_pass, write_data_pass, instruction_count);
    end

endmodule
