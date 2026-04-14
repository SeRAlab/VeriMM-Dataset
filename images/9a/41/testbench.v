`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg reset;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        data_in = 16'h0000;
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Synchronous Reset Check", test_num);
        reset_dut();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Single Bit Shift Left (1)", test_num);
        reset_dut();
        data_in = 16'h0001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Sequence Shift Left (101)", test_num);
        reset_dut();
        data_in = 1; @(posedge clk);
        data_in = 0; @(posedge clk);
        data_in = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0005);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = 4;
        $display("Testcase %03d: Fill Register (16 shifts)", test_num);
        reset_dut();
        data_in = 1;
        repeat(16) @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Overflow Check", test_num);
        reset_dut();
        data_in = 1;
        repeat(16) @(posedge clk);
        data_in = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = 6;
        $display("Testcase %03d: Pattern AAAA", test_num);
        reset_dut();
        for (i = 0; i < 8; i = i + 1) begin
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
        end
        #1;
        #1;

        check_outputs(16'hAAAA);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, reset, data_out);
    end

endmodule
