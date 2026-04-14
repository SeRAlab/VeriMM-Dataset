`timescale 1ns/1ps

module sipo_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sipo_shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 0;
        data_in = 0;
        @(negedge clk);
        rst = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test %0d: Shift in 11111", test_num);
        data_in = 1;
        repeat (5) @(posedge clk);
        #1 #1;
 check_outputs(5'b11111);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test %0d: Shift pattern 10110", test_num);
        @(negedge clk) data_in = 1;
        @(negedge clk) data_in = 0;
        @(negedge clk) data_in = 1;
        @(negedge clk) data_in = 1;
        @(negedge clk) data_in = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(5'b10110);
    end
        endtask

    task testcase003;

    begin

        data_in = 1;
        repeat (5) @(posedge clk);

        reset_dut();
        test_num = 3;
        $display("Test %0d: Shift in all zeros", test_num);
        data_in = 0;
        repeat (5) @(posedge clk);
        #1 #1;
 check_outputs(5'b00000);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test %0d: Overflow check (Input 1 followed by five 0s)", test_num);
        @(negedge clk) data_in = 1;
        repeat (5) begin
            @(negedge clk) data_in = 0;
        end
        @(posedge clk);

        #1 #1;
 check_outputs(5'b00000);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test %0d: Reset mid-operation", test_num);
        data_in = 1;
        repeat (3) @(posedge clk);


        @(negedge clk);
        rst = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(5'b00000);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test %0d: Alternating bits 01010", test_num);
        @(negedge clk) data_in = 0;
        @(negedge clk) data_in = 1;
        @(negedge clk) data_in = 0;
        @(negedge clk) data_in = 1;
        @(negedge clk) data_in = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(5'b01010);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sipo_shift_register Testbench");
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
        input [4:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, rst, data_out);
    end

endmodule
