`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg direction;
    reg rst;
    reg shift_in;
    wire [15:0] shift_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .direction(direction),
        .rst(rst),
        .shift_in(shift_in),
        .shift_reg(shift_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            direction = 0;
            shift_in = 0;
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Asynchronous Reset");
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Left Shift (4 bits)");
            reset_dut();
            direction = 1;
            shift_in = 1;
            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Right Shift (4 bits)");
            reset_dut();
            direction = 0;
            shift_in = 1;
            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hF000);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Test Case 004: Left Shift - Fill 16-bit Pattern");
            reset_dut();
            direction = 1;
            for (i = 0; i < 16; i = i + 1) begin
                shift_in = (i % 2 == 0) ? 1 : 0;
                @(posedge clk);
            end
            #1;


            #1;



            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Test Case 005: Right Shift - Fill 16-bit Pattern");
            reset_dut();
            direction = 0;
            for (i = 0; i < 16; i = i + 1) begin
                shift_in = 1;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Direction Switch");
            reset_dut();

            direction = 1;
            shift_in = 1;
            repeat (4) @(posedge clk);

            direction = 0;
            shift_in = 0;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0003);
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
        input [15:0] expected_shift_reg;
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
        $dumpvars(0,clk, direction, rst, shift_in, shift_reg);
    end

endmodule
