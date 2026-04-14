`timescale 1ns/1ps

module shift_register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg serial_in;
    wire [7:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit dut (
        .clk(clk),
        .serial_in(serial_in),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin
            serial_in = 0;
            repeat(8) @(negedge clk);
            #1;
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting in alternating bits 10101010", test_num);
            reset_dut();
            pattern = 8'b10101010;


            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge clk);
                serial_in = pattern[i];
            end


            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b10101010);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting in 11110000", test_num);
            reset_dut();
            pattern = 8'b11110000;

            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge clk);
                serial_in = pattern[i];
            end

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b11110000);
        end
        endtask

    task testcase003;

        integer i;
        reg [11:0] sequence;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow check (12 bits: 1101_1010_1111)", test_num);
            reset_dut();
            sequence = 12'b1101_1010_1111;

            for (i = 11; i >= 0; i = i - 1) begin
                @(negedge clk);
                serial_in = sequence[i];
            end

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'b10101111);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting in all ones", test_num);
            reset_dut();

            serial_in = 1;
            repeat(8) @(negedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting in 00000001", test_num);
            reset_dut();


            repeat(7) begin
                @(negedge clk) serial_in = 0;
            end
            @(negedge clk) serial_in = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h",
                         parallel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h",
                         expected_parallel_out);
                $display("  Got:      parallel_out=%h",
                         parallel_out);
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
        $dumpvars(0,clk, serial_in, parallel_out);
    end

endmodule
