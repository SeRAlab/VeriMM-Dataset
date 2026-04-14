`timescale 1ns/1ps

module sync_up_counter_6bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg sync_reset;
    wire [5:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_up_counter_6bit dut (
        .clk(clk),
        .enable(enable),
        .sync_reset(sync_reset),
        .count_out(count_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sync_reset = 1;
            enable = 0;
            @(posedge clk);
            #1;
            sync_reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Reset", test_num);
            reset_dut();
            @(negedge clk);
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Increment to 10", test_num);
            reset_dut();
            enable = 1;
            repeat(10) @(posedge clk);
            enable = 0;
            @(negedge clk);
            #1;

            check_outputs(6'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Disable signal holds value", test_num);
            reset_dut();
            enable = 1;
            repeat(5) @(posedge clk);
            enable = 0;
            repeat(5) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(6'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Wrap around check (63 to 0)", test_num);
            reset_dut();
            enable = 1;
            repeat(64) @(posedge clk);
            enable = 0;
            @(negedge clk);
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Synchronous reset during operation", test_num);
            reset_dut();
            enable = 1;
            repeat(20) @(posedge clk);
            sync_reset = 1;
            @(posedge clk);
            sync_reset = 0;
            enable = 0;
            @(negedge clk);
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Intermittent enable signal", test_num);
            reset_dut();

            enable = 1;
            repeat(5) @(posedge clk);
            enable = 0;
            repeat(2) @(posedge clk);
            enable = 1;
            repeat(3) @(posedge clk);
            enable = 0;

            @(negedge clk);
            #1;

            check_outputs(6'd8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Count to maximum value (63)", test_num);
            reset_dut();
            enable = 1;
            repeat(63) @(posedge clk);
            enable = 0;
            @(negedge clk);
            #1;

            check_outputs(6'd63);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_up_counter_6bit Testbench");
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
        input [5:0] expected_count_out;
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
        $dumpvars(0,clk, enable, sync_reset, count_out);
    end

endmodule
