`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg load;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .q(q)
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
        data_in = 4'b0000;
        @(negedge clk);
        load = 0;
        data_in = 4'b0000;
    end
        endtask
    task testcase001;

    begin
        $display("testcase001: Parallel Load");
        reset_dut();
        @(negedge clk);
        load = 1;
        data_in = 4'b1010;
        @(negedge clk);
        load = 0;

        #1;


        check_outputs(4'b1010);
    end
        endtask

    task testcase002;

    begin
        $display("testcase002: Single Right Shift");
        reset_dut();

        @(negedge clk);
        load = 1;
        data_in = 4'b1000;
        @(negedge clk);
        load = 0;
        @(negedge clk);

        #1;


        check_outputs(4'b0100);
    end
        endtask

    task testcase003;

    begin
        $display("testcase003: Multiple Right Shifts");
        reset_dut();

        @(negedge clk);
        load = 1;
        data_in = 4'b1100;
        @(negedge clk);
        load = 0;

        repeat(2) @(negedge clk);

        #1;


        check_outputs(4'b0011);
    end
        endtask

    task testcase004;

    begin
        $display("testcase004: Shift until empty");
        reset_dut();

        @(negedge clk);
        load = 1;
        data_in = 4'b0001;
        @(negedge clk);
        load = 0;

        repeat(2) @(negedge clk);

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase005;

    begin
        $display("testcase005: Load Priority");
        reset_dut();

        @(negedge clk);
        load = 1;
        data_in = 4'b1111;
        @(negedge clk);

        data_in = 4'b0101;
        @(negedge clk);

        #1;


        check_outputs(4'b0101);
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, data_in, load, q);
    end

endmodule
