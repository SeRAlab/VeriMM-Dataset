`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg up_down;
    wire [3:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .reset(reset),
        .up_down(up_down),
        .count_out(count_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            up_down = 1;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Increment 5 times", test_num);
            reset_dut();
            up_down = 1;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Overflow wrap-around (16 cycles)", test_num);
            reset_dut();
            up_down = 1;
            repeat(16) @(posedge clk);
            #1 #1;
 check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Underflow wrap-around (Decrement at 0)", test_num);
            reset_dut();
            up_down = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Direction switching", test_num);
            reset_dut();
            up_down = 1;
            repeat(10) @(posedge clk);
            up_down = 0;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(4'h7);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Count to Max (15)", test_num);
            reset_dut();
            up_down = 1;
            repeat(15) @(posedge clk);
            #1 #1;
 check_outputs(4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter Testbench");
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
        input [3:0] expected_count_out;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h",
                         count_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h",
                         expected_count_out);
                $display("  Got:      count_out=%h",
                         count_out);
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
        $dumpvars(0,clk, reset, up_down, count_out);
    end

endmodule
