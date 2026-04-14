`timescale 1ns/1ps

module PIPO_Shift_Register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg load;
    reg output_enable;
    reg rst;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PIPO_Shift_Register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .output_enable(output_enable),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            output_enable = 0;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset and Output Enable Check", test_num);
            reset_dut();
            output_enable = 1;
            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Parallel Load", test_num);
            reset_dut();
            data_in = 5'b10101;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            output_enable = 1;
            #1;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Output Enable De-assertion", test_num);
            reset_dut();
            data_in = 5'b11111;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            output_enable = 0;
            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Load Disable Check", test_num);
            reset_dut();

            data_in = 5'b01100;
            load = 1;
            @(posedge clk);
            #1;

            data_in = 5'b11111;
            load = 0;
            @(posedge clk);
            #1;
            output_enable = 1;
            #1;
            #1;

            check_outputs(5'b01100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Mid-operation Reset", test_num);
            reset_dut();

            data_in = 5'b11011;
            load = 1;
            @(posedge clk);
            #1;

            rst = 1;
            #1;
            output_enable = 1;
            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Sequential Loads", test_num);
            reset_dut();
            output_enable = 1;

            data_in = 5'b00001; load = 1; @(posedge clk);
            #1;
            data_in = 5'b00010; load = 1; @(posedge clk);
            #1;
            data_in = 5'b00100; load = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PIPO_Shift_Register Testbench");
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
        input [4:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, load, output_enable, rst, data_out);
    end

endmodule
