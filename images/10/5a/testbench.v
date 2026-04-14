`timescale 1ns/1ps

module mersenne_twister_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start;
    wire [31:0] random_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mersenne_twister dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .random_num(random_num)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("--- Resetting DUT ---");
            reset = 1;
            start = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Post-Reset Idle State", test_num);
            reset_dut();

            repeat (5) @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single Cycle Generation", test_num);
            reset_dut();

            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            @(posedge clk);
            #1;


            if (random_num != 32'h0) begin
                $display("PASS: Generated non-zero random number: %h", random_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Output remained zero after start");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        reg [31:0] first_val;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Repeatability Test", test_num);


            reset_dut();
            start = 1;
            repeat(5) @(posedge clk);
            #1;
            first_val = random_num;
            start = 0;


            reset_dut();
            start = 1;
            repeat(5) @(posedge clk);
            #1;
            start = 0;

            #1;


            check_outputs(first_val);
        end
        endtask

    task testcase004;

        reg [31:0] paused_val;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Pause and Resume Logic", test_num);
            reset_dut();


            start = 1;
            repeat(3) @(posedge clk);
            #1;
            start = 0;
            paused_val = random_num;


            repeat(5) @(posedge clk);
            #1;


            if (random_num === paused_val) begin
                $display("PASS: Output held during pause: %h", random_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Output changed while start was low");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        reg [31:0] val_a, val_b;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Multi-cycle Sequence Generation", test_num);
            reset_dut();

            start = 1;
            @(posedge clk); #1;
            val_a = random_num;
            @(posedge clk); #1;
            val_b = random_num;


            if (val_a != val_b) begin
                $display("PASS: Sequence is progressing (%h -> %h)", val_a, val_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Sequence stuck at value %h", val_a);
                fail_count = fail_count + 1;
            end
            start = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mersenne_twister Testbench");
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
        input [31:0] expected_random_num;
        begin
            if (expected_random_num === (expected_random_num ^ random_num ^ expected_random_num)) begin
                $display("PASS");
                $display("  Outputs: random_num=%h",
                         random_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: random_num=%h",
                         expected_random_num);
                $display("  Got:      random_num=%h",
                         random_num);
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
        $dumpvars(0,clk, reset, start, random_num);
    end

endmodule
