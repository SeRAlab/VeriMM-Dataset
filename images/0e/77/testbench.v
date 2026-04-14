`timescale 1ns/1ps

module SIPO_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg serial_in;
    wire [4:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SIPO dut (
        .clk(clk),
        .enable(enable),
        .serial_in(serial_in),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 1;
            serial_in = 0;
            repeat (5) @(negedge clk);
            enable = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic 5-bit sequence (10110)", test_num);
            reset_dut();

            enable = 1;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 0;

            @(posedge clk); #1;
            #1;

            check_outputs(5'b10110);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fill with all ones (11111)", test_num);
            reset_dut();

            enable = 1;
            repeat (5) begin
                @(negedge clk) serial_in = 1;
            end

            @(posedge clk); #1;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable/Disable Toggle - Maintain State", test_num);
            reset_dut();


            enable = 1;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 1;


            @(negedge clk) enable = 0;
            serial_in = 0;
            repeat (2) @(negedge clk);

            @(posedge clk); #1;
            #1;

            check_outputs(5'b00101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Interleaved shifting and holding", test_num);
            reset_dut();

            enable = 1;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;

            enable = 0;
            @(negedge clk) serial_in = 0;

            enable = 1;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 1;

            @(posedge clk); #1;
            #1;

            check_outputs(5'b11001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overflow - Shift 6 bits (oldest bit drops)", test_num);
            reset_dut();

            enable = 1;

            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 1;

            @(posedge clk); #1;
            #1;

            check_outputs(5'b01101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SIPO Testbench");
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
        input [4:0] expected_parallel_out;
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
        $dumpvars(0,clk, enable, serial_in, parallel_out);
    end

endmodule
