`timescale 1ns/1ps

module delay_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] count;
    reg load;
    reg reset;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    delay_counter dut (
        .clk(clk),
        .count(count),
        .load(load),
        .reset(reset),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        load = 0;
        count = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Loading zero count", test_num);
        reset_dut();

        count = 32'd0;
        load = 1;
        @(posedge clk);
        load = 0;


        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Small countdown (5 cycles)", test_num);
        reset_dut();

        count = 32'd5;
        load = 1;
        @(posedge clk);
        load = 0;


        repeat(5) @(posedge clk);

        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Check 'done' is low during active count", test_num);
        reset_dut();

        count = 32'd10;
        load = 1;
        @(posedge clk);
        load = 0;


        repeat(5) @(posedge clk);

        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Overriding count with new load", test_num);
        reset_dut();


        count = 32'd20;
        load = 1;
        @(posedge clk);
        load = 0;

        repeat(5) @(posedge clk);


        count = 32'd3;
        load = 1;
        @(posedge clk);
        load = 0;

        repeat(3) @(posedge clk);

        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Large count value (100 cycles)", test_num);
        reset_dut();

        count = 32'd100;
        load = 1;
        @(posedge clk);
        load = 0;

        repeat(100) @(posedge clk);

        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Check persistence of 'done' signal", test_num);
        reset_dut();

        count = 32'd2;
        load = 1;
        @(posedge clk);
        load = 0;

        repeat(2) @(posedge clk);
        repeat(10) @(posedge clk);

        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("delay_counter Testbench");
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
        input expected_done;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: done=%b",
                         done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b",
                         expected_done);
                $display("  Got:      done=%b",
                         done);
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
        $dumpvars(0,clk, count, load, reset, done);
    end

endmodule
