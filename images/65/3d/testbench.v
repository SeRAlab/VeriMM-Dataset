`timescale 1ns/1ps

module shift_register_8_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg rst;
    reg shift_left;
    reg shift_right;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8 dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst(rst),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            shift_left = 0;
            shift_right = 0;
            data_in = 8'b0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Parallel Load");
            reset_dut();
            data_in = 8'hA5;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shift Left Once");
            reset_dut();

            data_in = 8'h01;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            shift_left = 1;
            @(posedge clk);
            #1;
            shift_left = 0;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Shift Right Once");
            reset_dut();

            data_in = 8'h80;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            shift_right = 1;
            @(posedge clk);
            #1;
            shift_right = 0;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Shift Left 4 Times");
            reset_dut();
            data_in = 8'h0F;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift_left = 1;
            repeat(4) @(posedge clk);
            #1;
            shift_left = 0;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Shift Right 4 Times");
            reset_dut();
            data_in = 8'hF0;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift_right = 1;
            repeat(4) @(posedge clk);
            #1;
            shift_right = 0;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Hold Value");
            reset_dut();
            data_in = 8'h55;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift_left = 0;
            shift_right = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Load Priority Over Shift");
            reset_dut();
            data_in = 8'hAA;
            load = 1;
            shift_left = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift_left = 0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Shift out all bits");
            reset_dut();
            data_in = 8'hFF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift_left = 1;
            repeat(8) @(posedge clk);
            #1;
            shift_left = 0;
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
        $display("shift_register_8 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, load, rst, shift_left, shift_right, data_out);
    end

endmodule
