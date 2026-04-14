`timescale 1ns/1ps

module counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [15:0] load_value;
    reg reset;
    reg up_down;
    wire [15:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .reset(reset),
        .up_down(up_down),
        .count(count)
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
            up_down = 1;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Load Check", test_num);
            reset_dut();
            @(negedge clk);
            load_value = 16'hA5A5;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Increment Check", test_num);
            reset_dut();
            @(negedge clk);
            up_down = 1;
            repeat (10) @(posedge clk);
            #2 #1;
 check_outputs(16'h000A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Underflow Check (0 -> FFFF)", test_num);
            reset_dut();
            @(negedge clk);
            up_down = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Load then Increment", test_num);
            reset_dut();
            @(negedge clk);
            load_value = 16'h1234;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            up_down = 1;
            repeat (5) @(posedge clk);
            #2 #1;
 check_outputs(16'h1239);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Load then Decrement", test_num);
            reset_dut();
            @(negedge clk);
            load_value = 16'h0010;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            up_down = 0;
            repeat (6) @(posedge clk);
            #2 #1;
 check_outputs(16'h000A);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Overflow Check (FFFF -> 0000)", test_num);
            reset_dut();
            @(negedge clk);
            load_value = 16'hFFFE;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            up_down = 1;
            repeat (2) @(posedge clk);
            #2 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Load Priority Check", test_num);
            reset_dut();
            @(negedge clk);
            load_value = 16'h7777;
            load = 1;
            up_down = 1;
            @(posedge clk);
            #2 load = 0;
            #1;

            check_outputs(16'h7777);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [15:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, load, load_value, reset, up_down, count);
    end

endmodule
