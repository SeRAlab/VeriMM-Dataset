`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg shift_in;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .rst_n(rst_n),
        .shift_in(shift_in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            shift_in = 0;
            @(negedge clk);
            rst_n = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full Shift - All Ones", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                shift_in = 1;
                @(negedge clk);
            end
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        reg [7:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pattern Shift (0x5A)", test_num);
            reset_dut();
            pattern = 8'h5A;
            for (i = 7; i >= 0; i = i - 1) begin
                shift_in = pattern[i];
                @(negedge clk);
            end
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overflow Shift", test_num);
            reset_dut();

            repeat(4) begin
                shift_in = 1;
                @(negedge clk);
            end
            repeat(8) begin
                shift_in = 0;
                @(negedge clk);
            end
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Partial Shift (4 bits)", test_num);
            reset_dut();

            shift_in = 1; @(negedge clk);
            shift_in = 0; @(negedge clk);
            shift_in = 1; @(negedge clk);
            shift_in = 1; @(negedge clk);
            #1;

            check_outputs(8'h0B);
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, rst_n, shift_in, out);
    end

endmodule
