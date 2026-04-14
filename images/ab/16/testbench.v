`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    reg reset;
    reg shift;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .shift(shift),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 0;
            shift = 0;
            #15;
            reset = 0;
            #5;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Verifying Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = 2;
            $display("\nTestcase %0d: Basic 8-bit Shift (0xAA)", test_num);
            reset_dut();
            pattern = 8'b10101010;
            shift = 1;
            for (i = 0; i < 8; i = i + 1) begin
                in = pattern[7-i];
                @(posedge clk);
                #1;
            end
            shift = 0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = 3;
            $display("\nTestcase %0d: Basic 8-bit Shift (0x55)", test_num);
            reset_dut();
            pattern = 8'b01010101;
            shift = 1;
            for (i = 0; i < 8; i = i + 1) begin
                in = pattern[7-i];
                @(posedge clk);
                #1;
            end
            shift = 0;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Shift Enable Control Test", test_num);
            reset_dut();


            shift = 1;
            in = 1;
            repeat(4) @(posedge clk);
            #1;


            shift = 0;
            in = 0;
            repeat(2) @(posedge clk);
            #1;


            shift = 1;
            in = 1;
            repeat(4) @(posedge clk);
            #1;

            shift = 0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Overflow Test", test_num);
            reset_dut();

            shift = 1;
            in = 1;
            repeat(8) @(posedge clk);
            #1;

            in = 0;
            repeat(4) @(posedge clk);
            #1;

            shift = 0;
            #1;

            check_outputs(8'hF0);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, in, reset, shift, q);
    end

endmodule
