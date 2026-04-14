`timescale 1ns/1ps

module down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg [4:0] init_val;
    reg rst_n;
    wire [4:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter dut (
        .clk(clk),
        .en(en),
        .init_val(init_val),
        .rst_n(rst_n),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            en = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic countdown to zero");
            init_val = 5'd5;
            reset_dut();
            en = 1;

            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Enable low - counter should not decrement");
            init_val = 5'd10;
            reset_dut();
            en = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Wrap-around from 0 to 31");
            init_val = 5'd1;
            reset_dut();
            en = 1;


            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enable toggling during operation");
            init_val = 5'd20;
            reset_dut();

            en = 1;
            repeat (2) @(posedge clk);

            en = 0;
            repeat (3) @(posedge clk);

            en = 1;
            repeat (1) @(posedge clk);

            #1;
            #1;

            check_outputs(5'd17);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Mid-operation reset to a new initial value");
            init_val = 5'd30;
            reset_dut();

            en = 1;
            repeat (5) @(posedge clk);


            init_val = 5'd12;
            rst_n = 0;
            @(posedge clk);
            #1;
            rst_n = 1;

            #1;


            check_outputs(5'd12);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Count down from maximum 5-bit value");
            init_val = 5'd31;
            reset_dut();
            en = 1;
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd21);
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
        input [4:0] expected_count;
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
        $dumpvars(0,clk, en, init_val, rst_n, count);
    end

endmodule
