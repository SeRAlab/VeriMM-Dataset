`timescale 1ns/1ps

module shift_reg_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data;
    reg load;
    reg shift;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_4bit dut (
        .clk(clk),
        .data(data),
        .load(load),
        .shift(shift),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            load = 1;
            data = 4'b0000;
            shift = 0;
            @(negedge clk);
            load = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Parallel Load 4'b1010");
            load = 1;
            data = 4'b1010;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Load 4'b1000 and Shift Right Once");

            load = 1; data = 4'b1000; @(negedge clk);

            load = 0; shift = 1; @(negedge clk);
            shift = 0;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Load 4'b1100 and Shift Right Twice");

            load = 1; data = 4'b1100; @(negedge clk);

            load = 0; shift = 1; @(negedge clk);

            @(negedge clk);
            shift = 0;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Load 4'b0111 and Hold (No Load/Shift)");

            load = 1; data = 4'b0111; @(negedge clk);

            load = 0; shift = 0; @(negedge clk);
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Priority Check (Both Load and Shift active)");

            load = 1; data = 4'b1111; @(negedge clk);
            load = 1; data = 4'b0101; shift = 1; @(negedge clk);
            load = 0; shift = 0;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Shift Right 4 times (Clear register)");

            load = 1; data = 4'b1111; @(negedge clk);

            load = 0; shift = 1;
            repeat(4) @(negedge clk);
            shift = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_4bit Testbench");
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
        $dumpvars(0,clk, data, load, shift, q);
    end

endmodule
