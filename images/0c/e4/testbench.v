`timescale 1ns/1ps

module down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] init_value;
    reg reset;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter dut (
        .clk(clk),
        .init_value(init_value),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [3:0] val;
        begin
            @(negedge clk);
            reset = 1;
            init_value = val;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Count down from 5 to 0", test_num);
            reset_dut(4'd5);


            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Count down from 10, wait 5 cycles", test_num);
            reset_dut(4'd10);
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Count down from 15 to 0", test_num);
            reset_dut(4'd15);
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Count down from 1 to 0", test_num);
            reset_dut(4'd1);
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Start at 0, check wrapping/holding", test_num);
            reset_dut(4'd0);
            repeat(1) @(posedge clk);
            #1;


            #1;



            check_outputs(4'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("down_counter Testbench");
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
        $dumpvars(0,clk, init_value, reset, count);
    end

endmodule
