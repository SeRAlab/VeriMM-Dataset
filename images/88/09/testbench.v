`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg strobe;
    wire dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .strobe(strobe),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            strobe = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task run_transmission_test;

        input [7:0] test_data;
        reg [8:0] expected_stream;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\n--- Test Case %0d: Data = %b ---", test_num, test_data);


            expected_stream = {test_data, ^test_data};


            din = test_data;
            strobe = 1;
            @(posedge clk);
            #1;
            strobe = 0;
            din = 8'hxx;


            for (i = 8; i >= 0; i = i - 1) begin
                $display("Checking Bit %0d (Expected: %b)", 8-i, expected_stream[i]);
                #1;

                check_outputs(expected_stream[i]);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            run_transmission_test(8'b0000_0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            run_transmission_test(8'b1111_1111);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            run_transmission_test(8'b0000_0001);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            run_transmission_test(8'b1000_0000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            run_transmission_test(8'b1010_1010);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            run_transmission_test(8'b1101_0111);
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
        input expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%b",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%b",
                         expected_dout);
                $display("  Got:      dout=%b",
                         dout);
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
        $dumpvars(0,clk, din, strobe, dout);
    end

endmodule
