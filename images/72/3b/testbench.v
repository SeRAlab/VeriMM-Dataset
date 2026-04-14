`timescale 1ns/1ps

module loadable_counter_with_terminal_count_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg enable;
    reg load;
    reg reset;
    wire [7:0] count;
    wire terminal_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    loadable_counter_with_terminal_count dut (
        .clk(clk),
        .data(data),
        .enable(enable),
        .load(load),
        .reset(reset),
        .count(count),
        .terminal_count(terminal_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            enable = 0;
            load = 0;
            data = 8'h00;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load Operation (0xA5)", test_num);
            reset_dut();
            @(negedge clk);
            data = 8'hA5;
            load = 1;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(8'hA5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Count Up (5 cycles)", test_num);
            reset_dut();
            enable = 1;
            repeat(5) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(8'h05, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Terminal Count (255)", test_num);
            reset_dut();

            data = 8'hFE;
            load = 1;
            @(negedge clk);
            load = 0;
            enable = 1;
            @(negedge clk);
            enable = 0;
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Wrap Around (255 -> 0)", test_num);
            reset_dut();

            data = 8'hFF;
            load = 1;
            @(negedge clk);
            load = 0;
            enable = 1;
            @(negedge clk);
            enable = 0;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable Control (Count inhibited)", test_num);
            reset_dut();

            data = 8'h0A;
            load = 1;
            @(negedge clk);
            load = 0;
            enable = 0;
            repeat(10) @(negedge clk);
            #1;

            check_outputs(8'h0A, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load Priority Over Enable", test_num);
            reset_dut();

            data = 8'hCC;
            load = 1;
            enable = 1;
            @(negedge clk);
            load = 0;
            enable = 0;

            #1;


            check_outputs(8'hCC, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Terminal Count Triggered via Load", test_num);
            reset_dut();
            data = 8'hFF;
            load = 1;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("loadable_counter_with_terminal_count Testbench");
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
        input [7:0] expected_count;
        input expected_terminal_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_terminal_count === (expected_terminal_count ^ terminal_count ^ expected_terminal_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h, terminal_count=%b",
                         count, terminal_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, terminal_count=%b",
                         expected_count, expected_terminal_count);
                $display("  Got:      count=%h, terminal_count=%b",
                         count, terminal_count);
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
        $dumpvars(0,clk, data, enable, load, reset, count, terminal_count);
    end

endmodule
