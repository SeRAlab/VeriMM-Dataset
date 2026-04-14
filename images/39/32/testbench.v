`timescale 1ns/1ps

module serializer_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg reset;
    reg valid;
    wire [3:0] bit_counter;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer_16bit dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid(valid),
        .bit_counter(bit_counter),
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
            valid = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros (16'h0000)", test_num);
            reset_dut();
            data_in = 16'h0000;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones (16'hFFFF)", test_num);
            reset_dut();
            data_in = 16'hFFFF;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Bit LSB (16'h0001)", test_num);
            reset_dut();
            data_in = 16'h0001;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;
            repeat(15) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Bit MSB (16'h8000)", test_num);
            reset_dut();
            data_in = 16'h8000;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bits (16'hAAAA)", test_num);
            reset_dut();
            data_in = 16'hAAAA;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;
            repeat(15) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd15, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Post-Completion Reset Check", test_num);
            reset_dut();
            data_in = 16'hFFFF;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;
            repeat(16) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("serializer_16bit Testbench");
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
        input [3:0] expected_bit_counter;
        input expected_serial_out;
        begin
            if (expected_bit_counter === (expected_bit_counter ^ bit_counter ^ expected_bit_counter) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: bit_counter=%h, serial_out=%b",
                         bit_counter, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bit_counter=%h, serial_out=%b",
                         expected_bit_counter, expected_serial_out);
                $display("  Got:      bit_counter=%h, serial_out=%b",
                         bit_counter, serial_out);
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
        $dumpvars(0,clk, data_in, reset, valid, bit_counter, serial_out);
    end

endmodule
