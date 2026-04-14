`timescale 1ns/1ps

module shift_load_register_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg clk;
    reg load;
    reg reset;
    reg serial_in;
    reg shift;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_load_register dut (
        .D(D),
        .clk(clk),
        .load(load),
        .reset(reset),
        .serial_in(serial_in),
        .shift(shift),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            shift = 0;
            D = 0;
            serial_in = 0;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(negedge clk);
            load = 1;
            D = 4'b1010;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            shift = 1;
            serial_in = 1;
            @(negedge clk);
            serial_in = 1;
            @(negedge clk);
            shift = 0;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge clk);
            load = 1;
            D = 4'b1111;
            @(negedge clk);
            load = 0;
            shift = 1;
            serial_in = 0;
            @(negedge clk);
            shift = 0;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(negedge clk);
            load = 1;
            shift = 1;
            D = 4'b0101;
            serial_in = 1;
            @(negedge clk);
            load = 0;
            shift = 0;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge clk);
            load = 1;
            D = 4'b1111;
            @(negedge clk);
            load = 0;
            #2;
            reset = 1;
            #2;
            #1;

            check_outputs(4'b0000);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(negedge clk);
            shift = 1;
            serial_in = 1; @(negedge clk);
            serial_in = 0; @(negedge clk);
            serial_in = 1; @(negedge clk);
            serial_in = 1; @(negedge clk);
            shift = 0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_load_register Testbench");
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, clk, load, reset, serial_in, shift, Q);
    end

endmodule
