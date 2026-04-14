`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg serial_in;
    wire data_valid;
    wire [7:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .serial_in(serial_in),
        .data_valid(data_valid),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            serial_in = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task shift_byte;

        input [7:0] data;
        integer i;
        begin
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = data[i];
                @(posedge clk);
            end

            #1;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase001: Input 0x00 (All Zeros)");
            reset_dut();
            shift_byte(8'h00);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase002: Input 0xFF (All Ones)");
            reset_dut();
            shift_byte(8'hFF);
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase003: Input 0xAA (10101010)");
            reset_dut();
            shift_byte(8'hAA);
            #1;

            check_outputs(1'b1, 8'hAA);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase004: Input 0x55 (01010101)");
            reset_dut();
            shift_byte(8'h55);
            #1;

            check_outputs(1'b1, 8'h55);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase005: Input 0xA5 (10100101)");
            reset_dut();
            shift_byte(8'hA5);
            #1;

            check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase006: Input 0x81 (10000001)");
            reset_dut();
            shift_byte(8'h81);
            #1;

            check_outputs(1'b1, 8'h81);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer Testbench");
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
        input expected_data_valid;
        input [7:0] expected_parallel_out;
        begin
            if (expected_data_valid === (expected_data_valid ^ data_valid ^ expected_data_valid) &&
                expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out)) begin
                $display("PASS");
                $display("  Outputs: data_valid=%b, parallel_out=%h",
                         data_valid, parallel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_valid=%b, parallel_out=%h",
                         expected_data_valid, expected_parallel_out);
                $display("  Got:      data_valid=%b, parallel_out=%h",
                         data_valid, parallel_out);
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
        $dumpvars(0,clk, serial_in, data_valid, parallel_out);
    end

endmodule
