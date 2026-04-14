`timescale 1ns/1ps

module deserializer_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg serial_in;
    wire [7:0] parallel_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer_8bit dut (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
        .parallel_out(parallel_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            serial_in = 0;
            #15;
            @(negedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task drive_serial;

        input [7:0] data;
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                serial_in = data[i];
            end

            @(posedge clk);
            #2;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Data 0x55 (Alternating bits 01010101)", test_num);
            drive_serial(8'h55);
            #1;

            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Data 0xAA (Alternating bits 10101010)", test_num);
            drive_serial(8'hAA);
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Data 0xFF (All ones)", test_num);
            drive_serial(8'hFF);
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Data 0x00 (All zeros)", test_num);
            drive_serial(8'h00);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Data 0xA5", test_num);
            drive_serial(8'hA5);
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Data 0x81", test_num);
            drive_serial(8'h81);
            #1;

            check_outputs(8'h81, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: Data 0x0F", test_num);
            drive_serial(8'h0F);
            #1;

            check_outputs(8'h0F, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test %0d: Data 0x12", test_num);
            drive_serial(8'h12);
            #1;

            check_outputs(8'h12, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer_8bit Testbench");
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
        input [7:0] expected_parallel_out;
        input expected_valid;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h, valid=%b",
                         parallel_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h, valid=%b",
                         expected_parallel_out, expected_valid);
                $display("  Got:      parallel_out=%h, valid=%b",
                         parallel_out, valid);
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
        $dumpvars(0,clk, reset, serial_in, parallel_out, valid);
    end

endmodule
