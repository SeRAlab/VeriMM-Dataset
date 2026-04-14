`timescale 1ns/1ps

module piso_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] parallel_in;
    reg reset;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    piso_shift_register dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .reset(reset),
        .serial_out(serial_out)
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
            parallel_in = 8'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase001: Checking output after reset...");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase002: Load 8'b10000000 and check MSB...");
            test_num = 2;
            reset_dut();
            parallel_in = 8'b10000000;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase003: Load 8'b01000000 and shift once to check bit 6...");
            test_num = 3;
            reset_dut();
            parallel_in = 8'b01000000;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase004: Load 8'b00000001 and shift 7 times to check LSB...");
            test_num = 4;
            reset_dut();
            parallel_in = 8'b00000001;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            for (i = 0; i < 7; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase005: Load 8'b11111111 and check MSB...");
            test_num = 5;
            reset_dut();
            parallel_in = 8'b11111111;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase006: Load 0xAA and check bit 6 (should be 0)...");
            test_num = 6;
            reset_dut();
            parallel_in = 8'b10101010;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        integer j;
        begin
            $display("Testcase007: Load 0x55 and check LSB (should be 1)...");
            test_num = 7;
            reset_dut();
            parallel_in = 8'b01010101;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            for (j = 0; j < 7; j = j + 1) begin
                @(posedge clk);
            end
            #1;
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
        $dumpvars(0,clk, load, parallel_in, reset, serial_out);
    end

endmodule
