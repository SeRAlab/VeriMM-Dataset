`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] shift_reg_out;
    wire [2:0] ena;
    wire [7:0] final_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .shift_reg_out(shift_reg_out),
        .ena(ena),
        .final_output(final_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            shift_reg_out = 8'h5A;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            #1;


            check_outputs(3'b000, 8'h5A);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            test_num = 2;

            #1;


            check_outputs(3'b000, 8'h5E);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            repeat(9) @(posedge clk);
            #1;
            test_num = 3;

            #1;


            check_outputs(3'b001, 8'h63);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            test_num = 4;

            #1;


            check_outputs(3'b000, 8'h6A);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            repeat(99) @(posedge clk);
            #1;
            test_num = 5;

            #1;


            check_outputs(3'b011, 8'hF3);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            shift_reg_out = 8'h05;
            repeat(5) @(posedge clk);
            #1;
            test_num = 6;

            #1;


            check_outputs(3'b000, 8'h0A);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            shift_reg_out = 8'hFF;
            repeat(1) @(posedge clk);
            #1;
            test_num = 7;

            #1;


            check_outputs(3'b000, 8'h00);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            repeat(999) @(posedge clk);
            #1;
            test_num = 8;

            #1;


            check_outputs(3'b111, 8'hF3);
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
        input [2:0] expected_ena;
        input [7:0] expected_final_output;
        begin
            if (expected_ena === (expected_ena ^ ena ^ expected_ena) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output)) begin
                $display("PASS");
                $display("  Outputs: ena=%h, final_output=%h",
                         ena, final_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ena=%h, final_output=%h",
                         expected_ena, expected_final_output);
                $display("  Got:      ena=%h, final_output=%h",
                         ena, final_output);
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
        $dumpvars(0,clk, reset, shift_reg_out, ena, final_output);
    end

endmodule
