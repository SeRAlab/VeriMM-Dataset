`timescale 1ns/1ps

module PISO_shift_reg_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg load;
    reg rst_n;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PISO_shift_reg dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst_n(rst_n),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        load = 0;
        data_in = 32'h0;
        @(negedge clk);
        rst_n = 1;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying reset state", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Load data 0x80000000 and check bit 31", test_num);
        reset_dut();
        data_in = 32'h8000_0000;
        load = 1;
        @(negedge clk);
        load = 0;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Load data 0x40000000 and shift once to check bit 30", test_num);
        reset_dut();
        data_in = 32'h4000_0000;
        load = 1;
        @(negedge clk);
        load = 0;
        @(negedge clk);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = 4;
        $display("Testcase %0d: Load data 0x00000001 and shift 31 times to check bit 0", test_num);
        reset_dut();
        data_in = 32'h0000_0001;
        load = 1;
        @(negedge clk);
        load = 0;
        for (i = 0; i < 31; i = i + 1) begin
            @(negedge clk);
        end

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = 5;
        $display("Testcase %0d: Verify output is 0 after shifting out all data", test_num);
        reset_dut();
        data_in = 32'hFFFF_FFFF;
        load = 1;
        @(negedge clk);
        load = 0;
        for (i = 0; i < 32; i = i + 1) begin
            @(negedge clk);
        end

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Load alternating pattern 0x55555555 and shift once", test_num);
        reset_dut();
        data_in = 32'h5555_5555;
        load = 1;
        @(negedge clk);
        load = 0;
        @(negedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PISO_shift_reg Testbench");
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
        input expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
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
        $dumpvars(0,clk, data_in, load, rst_n, data_out);
    end

endmodule
