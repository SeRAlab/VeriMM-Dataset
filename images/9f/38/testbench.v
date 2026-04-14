`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] external_in;
    reg reset;
    reg serial_in;
    wire [2:0] adder_out;
    wire [3:0] and_out;
    wire [3:0] shift_reg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .external_in(external_in),
        .reset(reset),
        .serial_in(serial_in),
        .adder_out(adder_out),
        .and_out(and_out),
        .shift_reg_out(shift_reg_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            serial_in = 0;
            external_in = 0;
            @(posedge clk);
            reset = 0;
        end
        endtask
    task shift_4_bits;

        input [3:0] data;
        integer i;
        begin
            for (i = 3; i >= 0; i = i - 1) begin
                serial_in = data[i];
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset State", test_num);
            reset_dut();



            external_in = 3'b101;
            #1;
            #1;

            check_outputs(3'b101, 4'b0000, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift 1011", test_num);
            reset_dut();
            shift_4_bits(4'b1011);

            external_in = 3'b010;


            #1;
            #1;

            check_outputs(3'b101, 4'b0001, 4'b1011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift 1111 with External 111", test_num);
            reset_dut();
            shift_4_bits(4'b1111);

            external_in = 3'b111;


            #1;
            #1;

            check_outputs(3'b110, 4'b0110, 4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift 0110 with External 001", test_num);
            reset_dut();
            shift_4_bits(4'b0110);

            external_in = 3'b001;


            #1;
            #1;

            check_outputs(3'b111, 4'b0110, 4'b0110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Serial continuity (5 bits shift)", test_num);
            reset_dut();

            serial_in = 1;
            @(posedge clk);
            shift_4_bits(4'b0000);

            external_in = 3'b011;
            #1;
            #1;

            check_outputs(3'b011, 4'b0000, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift 1000 with Zero Input", test_num);
            reset_dut();
            shift_4_bits(4'b1000);

            external_in = 3'b000;


            #1;
            #1;

            check_outputs(3'b000, 4'b0000, 4'b1000);
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
        input [2:0] expected_adder_out;
        input [3:0] expected_and_out;
        input [3:0] expected_shift_reg_out;
        begin
            if (expected_adder_out === (expected_adder_out ^ adder_out ^ expected_adder_out) &&
                expected_and_out === (expected_and_out ^ and_out ^ expected_and_out) &&
                expected_shift_reg_out === (expected_shift_reg_out ^ shift_reg_out ^ expected_shift_reg_out)) begin
                $display("PASS");
                $display("  Outputs: adder_out=%h, and_out=%h, shift_reg_out=%h",
                         adder_out, and_out, shift_reg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adder_out=%h, and_out=%h, shift_reg_out=%h",
                         expected_adder_out, expected_and_out, expected_shift_reg_out);
                $display("  Got:      adder_out=%h, and_out=%h, shift_reg_out=%h",
                         adder_out, and_out, shift_reg_out);
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
        $dumpvars(0,clk, external_in, reset, serial_in, adder_out, and_out, shift_reg_out);
    end

endmodule
