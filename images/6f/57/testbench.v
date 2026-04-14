`timescale 1ns/1ps

module shift_register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg serial_in;
    wire [7:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit dut (
        .clk(clk),
        .reset(reset),
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
            @(negedge clk);
            reset = 1;
            serial_in = 0;
            @(negedge clk);
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Power-on Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Test %03d: Shift in All Ones (0xFF)", test_num);
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                serial_in = 1'b1;
            end
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] data_to_shift;
        begin
            test_num = 3;
            $display("Test %03d: Shift in Pattern 0xAA (10101010)", test_num);
            data_to_shift = 8'hAA;
            reset_dut();

            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge clk);
                serial_in = data_to_shift[i];
            end
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] data_to_shift;
        begin
            test_num = 4;
            $display("Test %03d: Shift in Pattern 0x55 (01010101)", test_num);
            data_to_shift = 8'h55;
            reset_dut();
            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge clk);
                serial_in = data_to_shift[i];
            end
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        integer i;
        reg [11:0] sequence;
        begin
            test_num = 5;
            $display("Test %03d: Over-shifting (12 bits, verify last 8 remain)", test_num);

            sequence = 12'hDAE;
            reset_dut();
            for (i = 11; i >= 0; i = i - 1) begin
                @(negedge clk);
                serial_in = sequence[i];
            end
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %03d: Mid-shift Reset", test_num);
            reset_dut();

            repeat(4) begin
                @(negedge clk);
                serial_in = 1'b1;
            end

            @(negedge clk);
            reset = 1;
            @(negedge clk);
            reset = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
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
        $dumpvars(0,clk, reset, serial_in, parallel_out);
    end

endmodule
