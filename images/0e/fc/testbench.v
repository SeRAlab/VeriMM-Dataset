`timescale 1ns/1ps

module piso_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [4:0] parallel_data;
    reg shift;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    piso_shift_register dut (
        .clk(clk),
        .load(load),
        .parallel_data(parallel_data),
        .shift(shift),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 0;
            shift = 0;
            parallel_data = 5'b0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Load 5'b10101 and check MSB");
            reset_dut();
            parallel_data = 5'b10101;
            load = 1;
            @(negedge clk);
            load = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Load 5'b01000 and shift 1 time");
            reset_dut();
            parallel_data = 5'b01000;
            load = 1;
            @(negedge clk);
            load = 0;
            shift = 1;
            @(negedge clk);
            shift = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Load 5'b00100 and shift 2 times");
            reset_dut();
            parallel_data = 5'b00100;
            load = 1;
            @(negedge clk);
            load = 0;
            shift = 1;
            repeat(2) @(negedge clk);
            shift = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Load 5'b00010 and shift 3 times");
            reset_dut();
            parallel_data = 5'b00010;
            load = 1;
            @(negedge clk);
            load = 0;
            shift = 1;
            repeat(3) @(negedge clk);
            shift = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Load 5'b00001 and shift 4 times");
            reset_dut();
            parallel_data = 5'b00001;
            load = 1;
            @(negedge clk);
            load = 0;
            shift = 1;
            repeat(4) @(negedge clk);
            shift = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Load 5'b11000 and wait without shifting");
            reset_dut();
            parallel_data = 5'b11000;
            load = 1;
            @(negedge clk);
            load = 0;
            shift = 0;
            repeat(2) @(negedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("piso_shift_register Testbench");
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
        input expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b",
                         expected_serial_out);
                $display("  Got:      serial_out=%b",
                         serial_out);
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
        $dumpvars(0,clk, load, parallel_data, shift, serial_out);
    end

endmodule
