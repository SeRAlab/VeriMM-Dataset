`timescale 1ns/1ps

module timer_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [15:0] load_value;
    reg reset;
    wire timer_done;
    wire [15:0] timer_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    timer_16bit dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .reset(reset),
        .timer_done(timer_done),
        .timer_out(timer_out)
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
            load_value = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 16'h0005;
            @(negedge clk);
            load = 0;

            for (i = 0; i < 5; i = i + 1) @(negedge clk);
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 16'h000A;
            @(negedge clk);
            load = 0;

            for (i = 0; i < 4; i = i + 1) @(negedge clk);

            #1;


            check_outputs(1'b0, 16'h0006);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 16'h0003;
            @(negedge clk);
            load = 0;

            for (i = 0; i < 10; i = i + 1) @(negedge clk);
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 16'h0020;
            @(negedge clk);
            load = 0;
            for (i = 0; i < 5; i = i + 1) @(negedge clk);


            load = 1;
            load_value = 16'h0010;
            @(negedge clk);
            load = 0;
            @(negedge clk);
            #1;

            check_outputs(1'b0, 16'h000F);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 16'h00FF;
            @(negedge clk);
            load = 0;
            for (i = 0; i < 10; i = i + 1) @(negedge clk);


            reset = 1;
            @(negedge clk);
            reset = 0;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("timer_16bit Testbench");
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
        input expected_timer_done;
        input [15:0] expected_timer_out;
        begin
            if (expected_timer_done === (expected_timer_done ^ timer_done ^ expected_timer_done) &&
                expected_timer_out === (expected_timer_out ^ timer_out ^ expected_timer_out)) begin
                $display("PASS");
                $display("  Outputs: timer_done=%b, timer_out=%h",
                         timer_done, timer_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: timer_done=%b, timer_out=%h",
                         expected_timer_done, expected_timer_out);
                $display("  Got:      timer_done=%b, timer_out=%h",
                         timer_done, timer_out);
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
        $dumpvars(0,clk, load, load_value, reset, timer_done, timer_out);
    end

endmodule
