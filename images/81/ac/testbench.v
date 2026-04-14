`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg reset;
    reg shift_ctrl;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .shift_ctrl(shift_ctrl),
        .data_out(data_out)
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
            load = 0;
            shift_ctrl = 0;
            data_in = 8'h00;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Synchronous Reset", test_num);
            reset_dut();

            @(negedge clk);
            load = 1; data_in = 8'hFF;
            @(negedge clk);
            load = 0;

            reset = 1;
            @(negedge clk);
            reset = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Parallel Load 0xAA", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 8'hAA;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Shift Left (0x01 -> 0x02)", test_num);
            reset_dut();

            @(negedge clk);
            load = 1; data_in = 8'h01;
            @(negedge clk);
            load = 0;

            shift_ctrl = 1;
            @(negedge clk);
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Shift Left 3 times (0x07 -> 0x38)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1; data_in = 8'h07;
            @(negedge clk);
            load = 0; shift_ctrl = 1;
            repeat(3) @(negedge clk);
            #1;

            check_outputs(8'h38);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Shift Right (0x80 -> 0x40)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1; data_in = 8'h80;
            @(negedge clk);
            load = 0;

            shift_ctrl = 0;
            @(negedge clk);
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Shift Right 4 times (0xF0 -> 0x0F)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1; data_in = 8'hF0;
            @(negedge clk);
            load = 0; shift_ctrl = 0;
            repeat(4) @(negedge clk);
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Shift Left Out (0x80 -> 0x00)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1; data_in = 8'h80;
            @(negedge clk);
            load = 0; shift_ctrl = 1;
            @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Load Priority Over Shift", test_num);
            reset_dut();
            @(negedge clk);
            load = 1; data_in = 8'h55;
            shift_ctrl = 1;
            @(negedge clk);
            #1;

            check_outputs(8'h55);
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
        $dumpvars(0,clk, data_in, load, reset, shift_ctrl, data_out);
    end

endmodule
