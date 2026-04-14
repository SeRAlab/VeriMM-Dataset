`timescale 1ns/1ps

module shift_register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg serial_in;
    wire [7:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit dut (
        .clk(clk),
        .rst(rst),
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
            @(posedge clk);
            rst = 1;
            serial_in = 0;
            @(posedge clk);
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Verification", test_num);
            reset_dut();

            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift All Ones", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                serial_in = 1'b1;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Pattern 10101010", test_num);
            pattern = 8'b10101010;
            reset_dut();
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = pattern[i];
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 11001100", test_num);
            pattern = 8'b11001100;
            reset_dut();
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = pattern[i];
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Walking Bit (1 followed by 7 zeros)", test_num);
            reset_dut();

            serial_in = 1'b1;
            @(posedge clk);

            serial_in = 1'b0;
            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-operation Synchronous Reset", test_num);
            reset_dut();

            serial_in = 1'b1;
            repeat(4) @(posedge clk);

            rst = 1'b1;
            @(posedge clk);
            rst = 1'b0;
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        integer i;
        reg [9:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow (10-bit shift)", test_num);
            pattern = 10'b0110101011;
            reset_dut();
            for (i = 9; i >= 0; i = i - 1) begin
                serial_in = pattern[i];
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'hAB);
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
        $dumpvars(0,clk, rst, serial_in, parallel_out);
    end

endmodule
