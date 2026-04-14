`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data_in;
    reg mode;
    reg [1:0] shift_amount;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .mode(mode),
        .shift_amount(shift_amount),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        mode = 0;
        forever #5 mode = ~mode;
    end

        task reset_dut;

    begin
        data_in = 4'b0000;
        shift_amount = 2'b00;
        @(posedge mode);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        data_in = 4'b1011;
        shift_amount = 2'd1;
        @(posedge mode);
        #2;
        $display("Testcase %0d: Left Shift 1 (1011 << 1)", test_num);
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        data_in = 4'b1011;
        shift_amount = 2'd2;
        @(posedge mode);
        #2;
        $display("Testcase %0d: Left Shift 2 (1011 << 2)", test_num);
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        data_in = 4'b0111;
        shift_amount = 2'd3;
        @(posedge mode);
        #2;
        $display("Testcase %0d: Left Shift 3 (0111 << 3)", test_num);
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        data_in = 4'b1101;
        shift_amount = 2'd0;
        @(posedge mode);
        #2;
        $display("Testcase %0d: Left Shift 0 (1101 << 0)", test_num);
        #1;

        check_outputs(4'b1101);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        data_in = 4'b1011;
        shift_amount = 2'd1;


        @(posedge mode);
        #2;
        $display("Testcase %0d: Right Shift 1 (1011 >> 1)", test_num);
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        data_in = 4'b1011;
        shift_amount = 2'd2;
        @(posedge mode);
        #2;
        $display("Testcase %0d: Right Shift 2 (1011 >> 2)", test_num);
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        data_in = 4'b1101;
        shift_amount = 2'd3;
        @(posedge mode);
        #2;
        $display("Testcase %0d: Right Shift 3 (1101 >> 3)", test_num);
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = test_num + 1;
        data_in = 4'b1111;
        shift_amount = 2'd0;
        @(posedge mode);
        #2;
        $display("Testcase %0d: Right Shift 0 (1111 >> 0)", test_num);
        #1;

        check_outputs(4'b1111);
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
        input [3:0] expected_data_out;
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
        $dumpvars(0,data_in, mode, shift_amount, data_out);
    end

endmodule
