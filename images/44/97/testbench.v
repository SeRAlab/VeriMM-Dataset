`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ena_;
    reg [7:0] r0_dout;
    reg [7:0] r1_dout;
    reg rst_;
    wire [7:0] abus;
    wire [7:0] dbus;
    wire mem_we_;
    wire rdy_;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ena_(ena_),
        .r0_dout(r0_dout),
        .r1_dout(r1_dout),
        .rst_(rst_),
        .abus(abus),
        .dbus(dbus),
        .mem_we_(mem_we_),
        .rdy_(rdy_)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_ = 0;
            ena_ = 1;
            r0_dout = 8'h00;
            r1_dout = 8'h00;
            @(posedge clk);
            #2 rst_ = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard Operation Sequence", test_num);
            reset_dut();

            r0_dout = 8'hA5;
            r1_dout = 8'h5A;

            @(posedge clk);
            ena_ = 0;
            @(posedge clk);
            ena_ = 1;



            repeat(2) @(posedge clk);


            #1;
            #1;

            check_outputs(8'h00, 8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle State Check", test_num);
            reset_dut();

            ena_ = 1;
            repeat(5) @(posedge clk);


            #1;
            #1;

            check_outputs(8'h00, 8'h00, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Continuous Enable Check", test_num);
            reset_dut();

            r0_dout = 8'h12;
            r1_dout = 8'h34;

            @(posedge clk);
            ena_ = 0;


            repeat(3) @(posedge clk);


            #1;
            #1;

            check_outputs(8'h00, 8'h00, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        input [7:0] expected_abus;
        input [7:0] expected_dbus;
        input expected_mem_we_;
        input expected_rdy_;
        begin
            if (expected_abus === (expected_abus ^ abus ^ expected_abus) &&
                expected_dbus === (expected_dbus ^ dbus ^ expected_dbus) &&
                expected_mem_we_ === (expected_mem_we_ ^ mem_we_ ^ expected_mem_we_) &&
                expected_rdy_ === (expected_rdy_ ^ rdy_ ^ expected_rdy_)) begin
                $display("PASS");
                $display("  Outputs: abus=%h, dbus=%h, mem_we_=%b, rdy_=%b",
                         abus, dbus, mem_we_, rdy_);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: abus=%h, dbus=%h, mem_we_=%b, rdy_=%b",
                         expected_abus, expected_dbus, expected_mem_we_, expected_rdy_);
                $display("  Got:      abus=%h, dbus=%h, mem_we_=%b, rdy_=%b",
                         abus, dbus, mem_we_, rdy_);
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
        $dumpvars(0,clk, ena_, r0_dout, r1_dout, rst_, abus, dbus, mem_we_, rdy_);
    end

endmodule
