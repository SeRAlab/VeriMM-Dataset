`timescale 1ns/1ps

module binary_up_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg reset;
    wire carry;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_up_counter dut (
        .clk(clk),
        .en(en),
        .reset(reset),
        .carry(carry),
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
            en = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Check reset state");
            reset_dut();

            #1;


            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single increment");
            reset_dut();
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 3'b001);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Count to 4");
            reset_dut();
            en = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 3'b100);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Check carry at max count (7)");
            reset_dut();
            en = 1;
            repeat(7) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 3'b111);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Check wrap-around (7 to 0)");
            reset_dut();
            en = 1;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Disable counting mid-way");
            reset_dut();
            en = 1;
            repeat(3) @(posedge clk);
            en = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 3'b011);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Carry behavior when en=0 at count 7");
            reset_dut();
            en = 1;
            repeat(7) @(posedge clk);
            en = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 3'b111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_up_counter Testbench");
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
        input expected_carry;
        input [2:0] expected_count;
        begin
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, count=%h",
                         carry, count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, count=%h",
                         expected_carry, expected_count);
                $display("  Got:      carry=%b, count=%h",
                         carry, count);
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
        $dumpvars(0,clk, en, reset, carry, count);
    end

endmodule
