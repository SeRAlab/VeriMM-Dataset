`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    reg load;
    reg shift;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .in(in),
        .load(load),
        .shift(shift),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        load = 1;
        shift = 0;
        in = 4'b0000;
        @(negedge clk);
        load = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Parallel Load", test_num);
        reset_dut();

        load = 1;
        in = 4'b1010;
        shift = 0;
        @(negedge clk);
        load = 0;

        #1;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shift Left 1-bit", test_num);
        reset_dut();


        load = 1;
        in = 4'b0001;
        @(negedge clk);


        load = 0;
        shift = 1;
        @(negedge clk);
        shift = 0;

        #1;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shift Left 2-bits", test_num);
        reset_dut();


        load = 1;
        in = 4'b0011;
        @(negedge clk);


        load = 0;
        shift = 1;
        @(negedge clk);
        @(negedge clk);
        shift = 0;

        #1;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shift bits out", test_num);
        reset_dut();


        load = 1;
        in = 4'b1000;
        @(negedge clk);


        load = 0;
        shift = 1;
        repeat(4) @(negedge clk);
        shift = 0;

        #1;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Priority Check (Load vs Shift)", test_num);
        reset_dut();


        load = 1;
        shift = 1;
        in = 4'b1101;
        @(negedge clk);
        load = 0;
        shift = 0;

        #1;
        #1;

        check_outputs(4'b1101);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verify back-to-back load then shift", test_num);
        reset_dut();

        load = 1;
        in = 4'b1111;
        @(negedge clk);
        load = 0;
        shift = 1;
        @(negedge clk);
        shift = 0;

        #1;
        #1;

        check_outputs(4'b1110);
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
        $dumpvars(0,clk, in, load, shift, out);
    end

endmodule
