`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] w_bus_instr_word;
    reg [3:0] w_bus_write_back_reg;
    reg [7:0] w_bus_write_back_value;
    reg w_clock;
    reg w_reset;
    reg w_write_back;
    wire [7:0] w_bus_high_reg;
    wire [7:0] w_bus_low_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .w_bus_instr_word(w_bus_instr_word),
        .w_bus_write_back_reg(w_bus_write_back_reg),
        .w_bus_write_back_value(w_bus_write_back_value),
        .w_clock(w_clock),
        .w_reset(w_reset),
        .w_write_back(w_write_back),
        .w_bus_high_reg(w_bus_high_reg),
        .w_bus_low_reg(w_bus_low_reg)
    );

    // Clock generation (10ns period)
    initial begin
        w_clock = 0;
        forever #5 w_clock = ~w_clock;
    end

        task reset_dut;

        begin
            w_reset = 1;
            w_write_back = 0;
            w_bus_instr_word = 0;
            w_bus_write_back_reg = 0;
            w_bus_write_back_value = 0;
            @(posedge w_clock);
            #1;
            w_reset = 0;
            @(posedge w_clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset Check", test_num);
            reset_dut();

            w_bus_instr_word = 8'h12;
            #1;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Write/Read (Reg 5)", test_num);
            reset_dut();


            w_write_back = 1;
            w_bus_write_back_reg = 4'h5;
            w_bus_write_back_value = 8'hAA;
            @(posedge w_clock);
            #1;
            w_write_back = 0;


            w_bus_instr_word = 8'h55;
            #1;
            #1;

            check_outputs(8'hAA, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Reg 0 Constant Zero Check", test_num);
            reset_dut();


            w_write_back = 1;
            w_bus_write_back_reg = 4'h0;
            w_bus_write_back_value = 8'hFF;
            @(posedge w_clock);
            #1;


            w_bus_instr_word = 8'h00;
            #1;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Dual Bus Read (Reg 1 and Reg 15)", test_num);
            reset_dut();


            w_write_back = 1;
            w_bus_write_back_reg = 4'h1;
            w_bus_write_back_value = 8'h11;
            @(posedge w_clock);
            #1;


            w_bus_write_back_reg = 4'hF;
            w_bus_write_back_value = 8'hEF;
            @(posedge w_clock);
            #1;

            w_write_back = 0;

            w_bus_instr_word = 8'h1F;
            #1;
            #1;

            check_outputs(8'h11, 8'hEF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Write Enable (w_write_back) Check", test_num);
            reset_dut();


            w_write_back = 0;
            w_bus_write_back_reg = 4'h7;
            w_bus_write_back_value = 8'h77;
            @(posedge w_clock);
            #1;


            w_bus_instr_word = 8'h77;
            #1;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %03d: Multiple Register Integrity", test_num);
            reset_dut();

            w_write_back = 1;
            for (i = 1; i < 16; i = i + 1) begin
                w_bus_write_back_reg = i;
                w_bus_write_back_value = i + 8'hA0;
                @(posedge w_clock);
                #1;
            end
            w_write_back = 0;



            w_bus_instr_word = 8'hAE;
            #1;
            #1;

            check_outputs(8'hAA, 8'hAE);
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
        input [7:0] expected_w_bus_high_reg;
        input [7:0] expected_w_bus_low_reg;
        begin
            if (expected_w_bus_high_reg === (expected_w_bus_high_reg ^ w_bus_high_reg ^ expected_w_bus_high_reg) &&
                expected_w_bus_low_reg === (expected_w_bus_low_reg ^ w_bus_low_reg ^ expected_w_bus_low_reg)) begin
                $display("PASS");
                $display("  Outputs: w_bus_high_reg=%h, w_bus_low_reg=%h",
                         w_bus_high_reg, w_bus_low_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w_bus_high_reg=%h, w_bus_low_reg=%h",
                         expected_w_bus_high_reg, expected_w_bus_low_reg);
                $display("  Got:      w_bus_high_reg=%h, w_bus_low_reg=%h",
                         w_bus_high_reg, w_bus_low_reg);
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
        $dumpvars(0,w_bus_instr_word, w_bus_write_back_reg, w_bus_write_back_value, w_clock, w_reset, w_write_back, w_bus_high_reg, w_bus_low_reg);
    end

endmodule
