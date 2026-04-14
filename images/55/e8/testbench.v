`timescale 1ns/1ps

module register_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load;
    reg rst;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_16bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
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
        rst = 1;
        load = 0;
        data_in = 0;
        #15;
        rst = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verify Reset functionality", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verify synchronous load of 0xABCD", test_num);
        reset_dut();

        @(posedge clk);
        data_in = 16'hABCD;
        load = 1;

        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verify register holds value when load is low", test_num);
        reset_dut();


        @(posedge clk);
        data_in = 16'h5555;
        load = 1;

        @(posedge clk);

        data_in = 16'hAAAA;
        load = 0;

        @(posedge clk);
        #1;

        #1;


        check_outputs(16'h5555);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verify asynchronous reset overrides load", test_num);
        reset_dut();

        @(posedge clk);
        data_in = 16'hFFFF;
        load = 1;


        #7;
        rst = 1;
        #1;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verify loading boundary value 0xFFFF", test_num);
        reset_dut();

        @(posedge clk);
        data_in = 16'hFFFF;
        load = 1;

        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verify back-to-back synchronous loads", test_num);
        reset_dut();

        load = 1;
        @(posedge clk);
        data_in = 16'h1234;
        @(posedge clk);
        data_in = 16'h5678;
        @(posedge clk);
        data_in = 16'h9ABC;

        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h9ABC);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_16bit Testbench");
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
        $dumpvars(0,clk, data_in, load, rst, data_out);
    end

endmodule
