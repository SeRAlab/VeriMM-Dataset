`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] data_in;
    reg load;
    wire [3:0] shift_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clock(clock),
        .data_in(data_in),
        .load(load),
        .shift_reg(shift_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(negedge clock);
            load = 1;
            data_in = 4'b0000;
            @(negedge clock);
            load = 0;
            data_in = 4'b0000;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Parallel load 1010 and shift right once", test_num);
            @(negedge clock);
            load = 1;
            data_in = 4'b1010;
            @(negedge clock);
            load = 0;
            @(negedge clock);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Parallel load 1010 and shift right twice", test_num);
            @(negedge clock);
            load = 1;
            data_in = 4'b1010;
            @(negedge clock);
            load = 0;
            @(negedge clock);
            @(negedge clock);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Parallel load 1111 and shift right three times", test_num);
            @(negedge clock);
            load = 1;
            data_in = 4'b1111;
            @(negedge clock);
            load = 0;
            @(negedge clock);
            @(negedge clock);
            @(negedge clock);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Load LSB and shift right into zero", test_num);
            @(negedge clock);
            load = 1;
            data_in = 4'b0001;
            @(negedge clock);
            load = 0;
            @(negedge clock);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Verify load overrides shift on consecutive cycles", test_num);
            @(negedge clock);
            load = 1;
            data_in = 4'b1100;
            @(negedge clock);
            data_in = 4'b0011;
            @(negedge clock);
            #1;

            check_outputs(4'b0011);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [3:0] expected_shift_reg;
        begin
            if (expected_shift_reg === (expected_shift_reg ^ shift_reg ^ expected_shift_reg)) begin
                $display("PASS");
                $display("  Outputs: shift_reg=%h",
                         shift_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shift_reg=%h",
                         expected_shift_reg);
                $display("  Got:      shift_reg=%h",
                         shift_reg);
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
        $dumpvars(0,clock, data_in, load, shift_reg);
    end

endmodule
