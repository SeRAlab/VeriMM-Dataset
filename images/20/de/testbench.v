`timescale 1ns/1ps

module down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data;
    reg load;
    reg reset;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter dut (
        .clk(clk),
        .data(data),
        .load(load),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 0;
            load = 0;
            data = 4'b0000;
            @(negedge clk);
            reset = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Reset (Counter should be 0)", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Load (Load 4'hA)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 4'hA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Step Decrement (5 -> 4)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 4'h5;
            @(posedge clk);
            @(negedge clk);
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple Step Decrement (F -> 5)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 4'hF;
            @(posedge clk);
            @(negedge clk);
            load = 0;
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Count down to Zero (2 -> 0)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 4'h2;
            @(posedge clk);
            @(negedge clk);
            load = 0;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Wrap Around (0 -> F)", test_num);
            reset_dut();

            @(negedge clk);
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Priority (Reset active during Load)", test_num);
            reset_dut();
            @(negedge clk);
            reset = 0;
            load = 1;
            data = 4'h7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
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
        $dumpvars(0,clk, data, load, reset, count);
    end

endmodule
