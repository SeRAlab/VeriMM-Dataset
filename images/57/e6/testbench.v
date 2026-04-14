`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    reg [7:0] data_in;
    reg load;
    reg select;
    reg shift;
    wire [7:0] counter_out;
    wire [7:0] final_output;
    wire [7:0] shift_reg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RST(RST),
        .data_in(data_in),
        .load(load),
        .select(select),
        .shift(shift),
        .counter_out(counter_out),
        .final_output(final_output),
        .shift_reg_out(shift_reg_out)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            load = 0;
            shift = 0;
            select = 0;
            data_in = 8'h00;
            @(posedge CLK);
            #1 RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: System Reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Data and Select Shift Register", test_num);
            reset_dut();
            data_in = 8'hA5;
            load = 1;
            select = 0;
            @(posedge CLK);
            #1 load = 0;


            #1;



            check_outputs(bin_to_gray(8'd1), bin_to_gray(8'hA5), bin_to_gray(8'hA5));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting Operation", test_num);
            reset_dut();
            data_in = 8'h01;
            load = 1;
            @(posedge CLK);
            #1 load = 0;
            shift = 1;
            @(posedge CLK);
            #1 shift = 0;
            select = 0;


            #1;



            check_outputs(bin_to_gray(8'd2), bin_to_gray(8'd2), bin_to_gray(8'd2));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counter and Output Selection", test_num);
            reset_dut();
            repeat(4) @(posedge CLK);
            #1 select = 1;



            #1;




            check_outputs(bin_to_gray(8'd5), bin_to_gray(8'd5), bin_to_gray(8'd0));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0xFF and Check Counter Gray(10)", test_num);
            reset_dut();
            data_in = 8'hFF;
            load = 1;
            @(posedge CLK);
            #1 load = 0;
            repeat(8) @(posedge CLK);
            @(posedge CLK);
            #1 select = 1;


            #1;



            check_outputs(bin_to_gray(8'd10), bin_to_gray(8'd10), bin_to_gray(8'hFF));
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
        input [7:0] expected_counter_out;
        input [7:0] expected_final_output;
        input [7:0] expected_shift_reg_out;
        begin
            if (expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_shift_reg_out === (expected_shift_reg_out ^ shift_reg_out ^ expected_shift_reg_out)) begin
                $display("PASS");
                $display("  Outputs: counter_out=%h, final_output=%h, shift_reg_out=%h",
                         counter_out, final_output, shift_reg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_out=%h, final_output=%h, shift_reg_out=%h",
                         expected_counter_out, expected_final_output, expected_shift_reg_out);
                $display("  Got:      counter_out=%h, final_output=%h, shift_reg_out=%h",
                         counter_out, final_output, shift_reg_out);
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
        $dumpvars(0,CLK, RST, data_in, load, select, shift, counter_out, final_output, shift_reg_out);
    end

endmodule
