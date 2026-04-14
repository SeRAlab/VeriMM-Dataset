`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address;
    reg clock;
    wire [127:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            address = 8'd0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Load (Address < 128)", test_num);
            reset_dut();
            address = 8'd10;
            @(posedge clock);
            #1;
            #1;

            check_outputs({8'd10, 120'h0});
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Load Boundary (Address = 127)", test_num);
            reset_dut();
            address = 8'd127;
            @(posedge clock);
            #1;
            #1;

            check_outputs({8'd127, 120'h0});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single Shift Operation", test_num);
            reset_dut();
            address = 8'h80;
            @(posedge clock);
            #1;


            #1;



            check_outputs({8'h80, 8'h00, 112'h0});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Multiple Shift Operations", test_num);
            reset_dut();
            address = 8'd5;
            @(posedge clock);
            #1;
            address = 8'hA0;
            @(posedge clock);
            #1;
            address = 8'hB0;
            @(posedge clock);
            #1;
            address = 8'hC0;
            @(posedge clock);
            #1;





            #1;






            check_outputs({8'hC0, 8'hB0, 8'hA0, 8'h05, 104'h0});
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Interleaved Load and Shift", test_num);
            reset_dut();
            address = 8'hFF;


            address = 8'h81;
            @(posedge clock);
            #1;
            address = 8'h20;
            @(posedge clock);
            #1;

            #1;


            check_outputs({8'h20, 120'h0});
        end
        endtask

    task testcase006;

        integer i;
        reg [127:0] expected;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Full Register Shift Fill", test_num);
            reset_dut();
            expected = 128'h0;



            for (i = 0; i < 15; i = i + 1) begin
                address = 8'd128 + i;
                expected = {address, expected[127:8]};
                @(posedge clock);
                #1;
            end
            #1;

            check_outputs(expected);
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
        input [127:0] expected_q;
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
        $dumpvars(0,address, clock, q);
    end

endmodule
