`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data_in;
    reg load_en;
    reg shift_en;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .load_en(load_en),
        .shift_en(shift_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        load_en = 0;
        forever #5 load_en = ~load_en;
    end

        task reset_dut;

        begin
            data_in = 4'b0000;
            load_en = 0;
            shift_en = 0;
            pulse_clk();
        end
        endtask
    task pulse_clk;

        begin
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Parallel Load 4'b1010", test_num);
            data_in = 4'b1010;
            load_en = 1;
            shift_en = 0;
            pulse_clk();
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Load 4'b1000 then Shift Right once", test_num);

            data_in = 4'b1000;
            load_en = 1;
            pulse_clk();

            load_en = 0;
            shift_en = 1;
            pulse_clk();
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Load 4'b1000 then Shift 3 times", test_num);
            data_in = 4'b1000;
            load_en = 1;
            pulse_clk();
            load_en = 0;
            shift_en = 1;
            pulse_clk();
            pulse_clk();
            pulse_clk();
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Priority Check (Load should override Shift)", test_num);

            data_in = 4'hA;
            load_en = 1;
            pulse_clk();

            data_in = 4'h5;
            load_en = 1;
            shift_en = 1;
            pulse_clk();
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Hold State (load_en=0, shift_en=0)", test_num);
            data_in = 4'hF;
            load_en = 1;
            pulse_clk();
            load_en = 0;
            shift_en = 0;
            data_in = 4'h0;
            pulse_clk();
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Shift out all data to zero", test_num);
            data_in = 4'b0001;
            load_en = 1;
            pulse_clk();
            load_en = 0;
            shift_en = 1;
            pulse_clk();
            #1;

            check_outputs(4'b0000);
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
        $dumpvars(0,data_in, load_en, shift_en, data_out);
    end

endmodule
