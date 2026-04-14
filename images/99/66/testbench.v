`timescale 1ns/1ps

module shift_register_right_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg in_bit;
    reg reset;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_right dut (
        .clk(clk),
        .enable(enable),
        .in_bit(in_bit),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        enable = 0;
        in_bit = 0;
        reset = 1;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Initial Reset", test_num);
        reset_dut();
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Shift single '1' into MSB", test_num);
        reset_dut();
        @(posedge clk);
        enable = 1;
        in_bit = 1;
        @(posedge clk);
        enable = 0;
        #1 #1;
 check_outputs(4'b1000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Fill register with '1's (4 cycles)", test_num);
        reset_dut();
        enable = 1;
        in_bit = 1;
        repeat (4) @(posedge clk);
        enable = 0;
        #1 #1;
 check_outputs(4'b1111);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Pattern shift 1-0-1-1", test_num);
        reset_dut();
        enable = 1;

        in_bit = 1; @(posedge clk);
        in_bit = 0; @(posedge clk);
        in_bit = 1; @(posedge clk);
        in_bit = 1; @(posedge clk);

        enable = 0;
        #1 #1;
 check_outputs(4'b1101);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Enable signal inhibition", test_num);
        reset_dut();


        enable = 1;
        in_bit = 1;
        @(posedge clk);


        enable = 0;
        in_bit = 0;
        @(posedge clk);

        #1 #1;
 check_outputs(4'b1000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Reset priority over enable", test_num);
        reset_dut();


        enable = 1;
        in_bit = 1;
        @(posedge clk);


        reset = 1;
        enable = 1;
        in_bit = 1;
        @(posedge clk);

        reset = 0;
        #1 #1;
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
        $display("shift_register_right Testbench");
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
        input [3:0] expected_out;
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
        $dumpvars(0,clk, enable, in_bit, reset, out);
    end

endmodule
