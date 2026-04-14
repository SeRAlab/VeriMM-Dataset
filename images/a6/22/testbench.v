`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg reset;
    reg shift_in;
    wire [7:0] q;

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
        .shift_in(shift_in),
        .q(q)
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
        data_in = 8'h00;
        shift_in = 0;
        @(negedge clk);
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Synchronous Reset", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Parallel Load 8'hA5", test_num);
        reset_dut();
        @(negedge clk);
        load = 1;
        data_in = 8'hA5;
        @(negedge clk);
        load = 0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Shift Left 1-bit (0x01 -> 0x02)", test_num);
        reset_dut();
        @(negedge clk);
        load = 1;
        data_in = 8'h01;
        @(negedge clk);
        load = 0;
        shift_in = 0;
        @(negedge clk);
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Shift Left 1-bit with shift_in=1", test_num);
        reset_dut();
        @(negedge clk);
        load = 1;
        data_in = 8'h01;
        @(negedge clk);
        load = 0;
        shift_in = 1;
        @(negedge clk);
        #1;

        check_outputs(8'h03);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Sequence Shift (Load 0, shift in 1-1-0-1)", test_num);
        reset_dut();
        @(negedge clk);
        load = 0;
        shift_in = 1; @(negedge clk);
        shift_in = 1; @(negedge clk);
        shift_in = 0; @(negedge clk);
        shift_in = 1; @(negedge clk);
        #1;

        check_outputs(8'h0D);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Shift Left Overflow (MSB lost)", test_num);
        reset_dut();
        @(negedge clk);
        load = 1;
        data_in = 8'h80;
        @(negedge clk);
        load = 0;
        shift_in = 0;
        @(negedge clk);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Reset Priority over Load signal", test_num);
        reset_dut();
        @(negedge clk);
        reset = 1;
        load = 1;
        data_in = 8'hFF;
        @(negedge clk);
        reset = 0;
        load = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase008;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test %03d: Fill register with 1s via shift_in", test_num);
        reset_dut();
        @(negedge clk);
        load = 0;
        shift_in = 1;
        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk);
        end
        #1;

        check_outputs(8'hFF);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data_in, load, reset, shift_in, q);
    end

endmodule
