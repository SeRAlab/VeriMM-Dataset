`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset;
    reg shift_dir;
    wire [7:0] shift_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .shift_dir(shift_dir),
        .shift_out(shift_out)
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
            data_in = 0;
            shift_dir = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = 2;
            $display("Testcase %0d: Shift Left 8-bits (0xAA)", test_num);
            reset_dut();
            shift_dir = 0;
            pattern = 8'b10101010;

            for (i = 0; i < 8; i = i + 1) begin
                data_in = pattern[0];
                pattern = pattern >> 1;
                @(negedge clk);
            end

            #1;


            check_outputs(8'b10101010);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = 3;
            $display("Testcase %0d: Shift Right 8-bits (0x0F)", test_num);
            reset_dut();
            shift_dir = 1;
            pattern = 8'b11110000;

            for (i = 0; i < 8; i = i + 1) begin
                data_in = pattern[i];
                @(negedge clk);
            end

            #1;


            check_outputs(8'h0F);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Left Shift Overflow", test_num);
            reset_dut();
            shift_dir = 0;
            data_in = 1;

            repeat (12) @(negedge clk);

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Bidirectional Shift Sequence", test_num);
            reset_dut();


            shift_dir = 0;
            data_in = 1;
            repeat (4) @(negedge clk);


            shift_dir = 1;
            data_in = 0;
            repeat (4) @(negedge clk);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Shift and Mid-operation Reset", test_num);
            reset_dut();
            shift_dir = 0;
            data_in = 1;
            repeat (4) @(negedge clk);


            @(negedge clk) reset = 1;
            @(negedge clk) reset = 0;

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
        $display("shift_register Testbench");
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
        input [7:0] expected_shift_out;
        begin
            if (expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: shift_out=%h",
                         shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shift_out=%h",
                         expected_shift_out);
                $display("  Got:      shift_out=%h",
                         shift_out);
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
        $dumpvars(0,clk, data_in, reset, shift_dir, shift_out);
    end

endmodule
