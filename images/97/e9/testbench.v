`timescale 1ns/1ps

module rotate_right_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg rst_n;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rotate_right dut (
        .clk(clk),
        .data_in(data_in),
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
        data_in = 0;
        repeat(2) @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Verify reset state", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Rotate 0x0001 right by 3", test_num);
        reset_dut();
        data_in = 16'h0001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h2000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Rotate 0x0007 right by 3", test_num);
        reset_dut();
        data_in = 16'h0007;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hE000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Rotate 0xFFFF right by 3", test_num);
        reset_dut();
        data_in = 16'hFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Rotate 0xAAAA right by 3", test_num);
        reset_dut();
        data_in = 16'hAAAA;
        @(posedge clk);
        #1;


        #1;



        check_outputs(16'h5555);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Rotate 0x1234 right by 3", test_num);
        reset_dut();
        data_in = 16'h1234;
        @(posedge clk);
        #1;


        #1;



        check_outputs(16'h8246);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rotate_right Testbench");
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
        $dumpvars(0,clk, data_in, rst_n, data_out);
    end

endmodule
