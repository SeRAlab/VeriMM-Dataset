`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ctrl;
    reg reset;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .ctrl(ctrl),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset functionality");
            reset_dut();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Up counting (5 steps)");
            reset_dut();
            ctrl = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Up counting wrap-around (16 steps)");
            reset_dut();
            ctrl = 1;
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Down counting underflow (0 to 15)");
            reset_dut();
            ctrl = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Down counting (4 steps)");
            reset_dut();
            ctrl = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd12);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Direction switching (Up 7, Down 3)");
            reset_dut();
            ctrl = 1;
            repeat(7) @(posedge clk);
            ctrl = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Synchronous reset while counting up");
            reset_dut();
            ctrl = 1;
            repeat(3) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Down counting wrap-around (17 steps)");
            reset_dut();
            ctrl = 0;
            repeat(17) @(posedge clk);
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
        $display("up_down_counter Testbench");
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, ctrl, reset, q);
    end

endmodule
