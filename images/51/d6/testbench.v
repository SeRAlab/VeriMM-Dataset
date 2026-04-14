`timescale 1ns/1ps

module register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] data_in;
    reg enable_n;
    reg reset;
    wire [11:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register dut (
        .clk(clk),
        .data_in(data_in),
        .enable_n(enable_n),
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
        reset = 1;
        enable_n = 1;
        data_in = 12'h0;
        #10;
        reset = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Checking Reset state", test_num);
        reset_dut();

        #1;


        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Loading data with enable_n = 0", test_num);
        reset_dut();

        enable_n = 0;
        data_in = 12'hABC;
        @(posedge clk);
        #1;

        #1;


        check_outputs(12'hABC);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Holding data with enable_n = 1", test_num);
        reset_dut();


        enable_n = 0;
        data_in = 12'h555;
        @(posedge clk);
        #1;


        enable_n = 1;
        data_in = 12'hAAA;
        @(posedge clk);
        #1;

        #1;


        check_outputs(12'h555);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Successive data loads", test_num);
        reset_dut();

        enable_n = 0;
        data_in = 12'h123;
        @(posedge clk);
        #1;
        data_in = 12'h456;
        @(posedge clk);
        #1;
        data_in = 12'h789;
        @(posedge clk);
        #1;

        #1;


        check_outputs(12'h789);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Loading boundary value 12'hFFF", test_num);
        reset_dut();

        enable_n = 0;
        data_in = 12'hFFF;
        @(posedge clk);
        #1;

        #1;


        check_outputs(12'hFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Asynchronous reset during operation", test_num);
        reset_dut();

        enable_n = 0;
        data_in = 12'hA5A;
        @(posedge clk);
        #1;


        #3;
        reset = 1;
        #1;

        #1;


        check_outputs(12'h000);
        reset = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register Testbench");
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
        input [11:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, enable_n, reset, data_out);
    end

endmodule
