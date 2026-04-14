`timescale 1ns/1ps

module up_down_counter_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst_n;
    reg up_down;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter_4bit dut (
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
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
            rst_n = 0;
            en = 0;
            up_down = 0;
            #15;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Basic Asynchronous Reset");
            reset_dut();
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Counting Up (4 cycles)");
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Counting Up with Wrap-around (18 cycles)");
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(18) @(posedge clk);
            #2;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Counting Down (1 cycle from 0)");
            reset_dut();
            en = 1;
            up_down = 0;
            repeat(1) @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Counting Down with Wrap-around (18 cycles)");
            reset_dut();
            en = 1;
            up_down = 0;
            repeat(18) @(posedge clk);
            #2;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Enable Signal (Hold value)");
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(5) @(posedge clk);
            en = 0;
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Direction Switching (10 Up, 4 Down)");
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(10) @(posedge clk);
            up_down = 0;
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Complex Sequence (Up 5, Down 2, Hold 3, Down 1)");
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(5) @(posedge clk);
            up_down = 0;
            repeat(2) @(posedge clk);
            en = 0;
            repeat(3) @(posedge clk);
            en = 1;
            repeat(1) @(posedge clk);
            #2;
            #1;

            check_outputs(4'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter_4bit Testbench");
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
        $dumpvars(0,clk, en, rst_n, up_down, count);
    end

endmodule
