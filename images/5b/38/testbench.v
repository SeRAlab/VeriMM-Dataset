`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset_n;
    reg shift_enable;
    wire [5:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .reset_n(reset_n),
        .shift_enable(shift_enable),
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
            reset_n = 0;
            shift_enable = 0;
            data_in = 0;
            @(negedge clk);
            reset_n = 1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Synchronous Reset");
            reset_dut();

            #1;


            check_outputs(6'b000000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Shift a single '1'");
            reset_dut();
            @(negedge clk);
            shift_enable = 1;
            data_in = 1;
            @(negedge clk);
            shift_enable = 0;

            #1;


            check_outputs(6'b100000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shift three bits (1, 0, 1)");
            reset_dut();
            @(negedge clk);
            shift_enable = 1;
            data_in = 1;
            @(negedge clk);
            data_in = 0;
            @(negedge clk);
            data_in = 1;
            @(negedge clk);
            shift_enable = 0;

            #1;


            check_outputs(6'b101000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Verify shift_enable=0 holds value");
            reset_dut();
            @(negedge clk);
            shift_enable = 1;
            data_in = 1;
            @(negedge clk);
            shift_enable = 0;
            data_in = 0;
            @(negedge clk);
            @(negedge clk);

            #1;


            check_outputs(6'b100000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Shift 6 bits to fill register (110110)");
            reset_dut();
            @(negedge clk);
            shift_enable = 1;
            data_in = 0; @(negedge clk);
            data_in = 1; @(negedge clk);
            data_in = 1; @(negedge clk);
            data_in = 0; @(negedge clk);
            data_in = 1; @(negedge clk);
            data_in = 1; @(negedge clk);
            shift_enable = 0;
            #1;

            check_outputs(6'b110110);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Synchronous Reset priority");
            reset_dut();
            @(negedge clk);
            shift_enable = 1;
            data_in = 1;
            @(negedge clk);
            @(negedge clk);
            reset_n = 0;
            @(negedge clk);
            reset_n = 1;

            #1;


            check_outputs(6'b000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [5:0] expected_q;
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
        $dumpvars(0,clk, data_in, reset_n, shift_enable, q);
    end

endmodule
