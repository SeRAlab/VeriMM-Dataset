`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] s422_data;
    reg s422_de;
    reg [7:0] s422_sync;
    wire [23:0] s444_data;
    wire [7:0] s444_sync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .s422_data(s422_data),
        .s422_de(s422_de),
        .s422_sync(s422_sync),
        .s444_data(s444_data),
        .s444_sync(s444_sync)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        s422_de <= 0;
        s422_sync <= 0;
        s422_data <= 0;
        repeat(5) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nRunning testcase%03d: Basic conversion", test_num);
        reset_dut();


        @(posedge clk);
        s422_de <= 1;
        s422_sync <= 8'hAA;
        s422_data <= 16'h1122;


        @(posedge clk);
        s422_de <= 1;
        s422_sync <= 8'hAA;
        s422_data <= 16'h3344;


        repeat(3) @(posedge clk);
        s422_de <= 0;





        #1;






        check_outputs(24'h332244, 8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nRunning testcase%03d: Sync propagation", test_num);
        reset_dut();

        @(posedge clk);
        s422_de <= 1;
        s422_sync <= 8'h55;
        s422_data <= 16'hAABB;

        @(posedge clk);
        s422_sync <= 8'hFF;
        s422_data <= 16'hCCDD;

        repeat(2) @(posedge clk);
        s422_de <= 0;


        #1;



        check_outputs(24'hCCBBDD, 8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nRunning testcase%03d: DE Gating", test_num);
        reset_dut();

        @(posedge clk);
        s422_de <= 0;
        s422_sync <= 8'h00;
        s422_data <= 16'hFFFF;

        repeat(3) @(posedge clk);


        #1;



        check_outputs(24'h000000, 8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nRunning testcase%04d: Continuous stream", test_num);
        reset_dut();

        @(posedge clk);
        s422_de <= 1;
        s422_sync <= 8'h01;
        s422_data <= 16'h1020;

        @(posedge clk);
        s422_data <= 16'h3040;

        @(posedge clk);
        s422_data <= 16'h5060;

        @(posedge clk);
        s422_data <= 16'h7080;

        repeat(2) @(posedge clk);
        s422_de <= 0;


        #1;



        check_outputs(24'h706080, 8'h01);
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
        testcase004();
        
        
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
        input [23:0] expected_s444_data;
        input [7:0] expected_s444_sync;
        begin
            if (expected_s444_data === (expected_s444_data ^ s444_data ^ expected_s444_data) &&
                expected_s444_sync === (expected_s444_sync ^ s444_sync ^ expected_s444_sync)) begin
                $display("PASS");
                $display("  Outputs: s444_data=%h, s444_sync=%h",
                         s444_data, s444_sync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s444_data=%h, s444_sync=%h",
                         expected_s444_data, expected_s444_sync);
                $display("  Got:      s444_data=%h, s444_sync=%h",
                         s444_data, s444_sync);
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
        $dumpvars(0,clk, s422_data, s422_de, s422_sync, s444_data, s444_sync);
    end

endmodule
