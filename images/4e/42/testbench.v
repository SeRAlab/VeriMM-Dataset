`timescale 1ns/1ps

module sync_up_down_counter_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg up_down;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_up_down_counter_4bit dut (
        .clk(clk),
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
            up_down = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Verification");
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Up Counting 5 steps");
            reset_dut();
            up_down = 1;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd5);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Up Counting Wrap Around (15 to 0)");
            reset_dut();
            up_down = 1;
            repeat(17) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Down Counting Wrap Around (0 to 15)");
            reset_dut();
            up_down = 0;
            repeat(1) @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Down Counting 6 steps from 0");
            reset_dut();
            up_down = 0;
            repeat(6) @(posedge clk);
            #1;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Up and Down Direction Switching");
            reset_dut();
            up_down = 1;
            repeat(10) @(posedge clk);
            up_down = 0;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd7);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Full sequence check");
            reset_dut();
            up_down = 1;
            repeat(16) @(posedge clk);
            up_down = 0;
            repeat(1) @(posedge clk);
            #1;

            #1;


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
        $display("sync_up_down_counter_4bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_count;
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
        $dumpvars(0,clk, reset, up_down, count);
    end

endmodule
