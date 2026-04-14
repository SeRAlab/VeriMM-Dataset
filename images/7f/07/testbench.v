`timescale 1ns/1ps

module binary_counter_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg en;
    wire carry;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter dut (
        .clear(clear),
        .clk(clk),
        .en(en),
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
            @(negedge clk);
            clear = 1;
            en = 0;
            @(negedge clk);
            clear = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset check");
            reset_dut();

            #1;


            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Increment count to 3");
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat (3) @(negedge clk);
            en = 0;

            #1;


            check_outputs(1'b0, 3'b011);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Carry flag at count 7");
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat (7) @(negedge clk);
            en = 0;

            #1;


            check_outputs(1'b1, 3'b111);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Wrap around from 7 to 0");
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat (8) @(negedge clk);
            en = 0;

            #1;


            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Disable enable mid-count");
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat (2) @(negedge clk);
            en = 0;
            repeat (2) @(negedge clk);

            #1;


            check_outputs(1'b0, 3'b010);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Synchronous clear during counting");
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat (4) @(negedge clk);
            clear = 1;
            @(negedge clk);
            clear = 0;
            en = 0;

            #1;


            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Carry flag drops after wrap");
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat (7) @(negedge clk);
            @(negedge clk);
            en = 0;
            #1;

            check_outputs(1'b0, 3'b000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter Testbench");
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
        $dumpvars(0,clear, clk, en, carry, count);
    end

endmodule
