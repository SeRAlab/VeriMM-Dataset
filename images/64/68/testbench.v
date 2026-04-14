`timescale 1ns/1ps

module up_down_counter_8_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg direction;
    reg enable;
    reg rst;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter_8 dut (
        .clk(clk),
        .direction(direction),
        .enable(enable),
        .rst(rst),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            direction = 1;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Up Counting (10 cycles)");
            reset_dut();
            enable = 1;
            direction = 1;
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Down Counting (Underflow check)");
            reset_dut();
            enable = 1;
            direction = 0;
            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFB);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enable Signal (Disable logic)");
            reset_dut();
            enable = 1;
            direction = 1;
            repeat (5) @(posedge clk);
            enable = 0;
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overflow Wrap Around");
            reset_dut();
            enable = 1;
            direction = 1;

            repeat (257) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Direction Switching");
            reset_dut();
            enable = 1;
            direction = 1;
            repeat (20) @(posedge clk);
            direction = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Intermittent Enable");
            reset_dut();
            direction = 1;

            repeat (10) begin
                enable = 1;
                @(posedge clk);
                enable = 0;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter_8 Testbench");
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
        input [7:0] expected_count;
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
        $dumpvars(0,clk, direction, enable, rst, count);
    end

endmodule
