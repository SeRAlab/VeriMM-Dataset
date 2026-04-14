`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg load;
    reg rst_n;
    reg shift;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst_n(rst_n),
        .shift(shift),
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
        shift = 0;
        data_in = 0;
        repeat(2) @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verify Reset functionality", test_num);
        reset_dut();

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Synchronous Load of 0xDEADBEEF", test_num);
        reset_dut();
        @(negedge clk);
        data_in = 32'hDEADBEEF;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Single Right Shift Operation", test_num);
        reset_dut();

        @(negedge clk);
        data_in = 32'h00000002;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        shift = 1;
        @(posedge clk);
        #1 shift = 0;

        #1;


        check_outputs(32'h00000001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Multiple Right Shifts (4 times)", test_num);
        reset_dut();

        @(negedge clk);
        data_in = 32'hF0000000;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        shift = 1;
        repeat(4) @(posedge clk);
        #1 shift = 0;

        #1;


        check_outputs(32'h0F000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Load Priority (Load and Shift both active)", test_num);
        reset_dut();


        @(negedge clk);
        data_in = 32'h12345678;
        load = 1;
        shift = 1;
        @(posedge clk);
        #1 load = 0;
        shift = 0;

        #1;


        check_outputs(32'h12345678);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Shift 32 times to clear register", test_num);
        reset_dut();

        @(negedge clk);
        data_in = 32'hFFFFFFFF;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        shift = 1;
        repeat(32) @(posedge clk);
        #1 shift = 0;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Data Stability (No operations)", test_num);
        reset_dut();

        @(negedge clk);
        data_in = 32'h5555AAAA;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        repeat(5) @(posedge clk);
        #1;

        check_outputs(32'h5555AAAA);
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, load, rst_n, shift, data_out);
    end

endmodule
