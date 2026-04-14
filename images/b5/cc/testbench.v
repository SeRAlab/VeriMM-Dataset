`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] data_in;
    reg load;
    reg shift;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .load(load),
        .shift(shift),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        load = 0;
        forever #5 load = ~load;
    end

        task reset_dut;

        begin

            load = 1;
            data_in = 8'h00;
            shift = 0;
            #10;
            shift = 1;
            #10;
            shift = 0;
            load = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel load 0x01 and shift once", test_num);
            reset_dut();


            load = 1;
            data_in = 8'h01;
            #10; shift = 1; #10; shift = 0;


            load = 0;
            #10; shift = 1; #10; shift = 0;

            #1;


            check_outputs(8'h02);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0x80 and shift once (check MSB drop)", test_num);
            reset_dut();


            load = 1;
            data_in = 8'h80;
            #10; shift = 1; #10; shift = 0;


            load = 0;
            #10; shift = 1; #10; shift = 0;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0xFF and shift 4 times", test_num);
            reset_dut();


            load = 1;
            data_in = 8'hFF;
            #10; shift = 1; #10; shift = 0;


            load = 0;
            for (i = 0; i < 4; i = i + 1) begin
                #10; shift = 1; #10; shift = 0;
            end

            #1;


            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0x55 and shift 8 times (clear register)", test_num);
            reset_dut();


            load = 1;
            data_in = 8'h55;
            #10; shift = 1; #10; shift = 0;


            load = 0;
            for (i = 0; i < 8; i = i + 1) begin
                #10; shift = 1; #10; shift = 0;
            end

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0xAA and verify no shift occurs without shift signal", test_num);
            reset_dut();


            load = 1;
            data_in = 8'hAA;
            #10; shift = 1; #10; shift = 0;


            load = 0;
            #20;

            #1;


            check_outputs(8'hAA);
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,data_in, load, shift, data_out);
    end

endmodule
