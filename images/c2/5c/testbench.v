`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg shift;
    reg [7:0] shift_in;
    wire [7:0] shift_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .rst(rst),
        .shift(shift),
        .shift_in(shift_in),
        .shift_out(shift_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            shift = 0;
            shift_in = 8'h00;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %03d: Basic shift 0xA5", test_num);
            shift_in = 8'hA5;
            @(posedge clk);
            shift = 1;
            @(posedge clk);
            shift = 0;
            @(posedge clk);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %03d: Basic shift 0x5A", test_num);
            shift_in = 8'h5A;
            @(posedge clk);
            shift = 1;
            @(posedge clk);
            shift = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %03d: Shift 0xFF", test_num);
            shift_in = 8'hFF;
            @(posedge clk);
            shift = 1;
            @(posedge clk);
            shift = 0;
            @(posedge clk);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %03d: Shift 0x00", test_num);
            shift_in = 8'h00;
            @(posedge clk);
            shift = 1;
            @(posedge clk);
            shift = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase %03d: Consecutive shifts 0x12, then 0x34", test_num);


            shift_in = 8'h12;
            @(posedge clk); shift = 1;
            @(posedge clk); shift = 0;


            @(posedge clk);
            shift_in = 8'h34;
            @(posedge clk); shift = 1;
            @(posedge clk); shift = 0;

            @(posedge clk);
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Running Testcase %03d: Reset mid-operation", test_num);

            shift_in = 8'hAA;
            @(posedge clk);
            shift = 1;
            @(posedge clk);

            rst = 1;
            #5;
            shift = 0;
            #5;
            rst = 0;

            @(posedge clk);
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
        $dumpvars(0,clk, rst, shift, shift_in, shift_out);
    end

endmodule
