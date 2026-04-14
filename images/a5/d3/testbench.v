`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg [3:0] in_data;
    reg wrenb;
    wire hit;
    wire [3:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .in_data(in_data),
        .wrenb(wrenb),
        .hit(hit),
        .out_data(out_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wrenb = 0;
            in_data = 4'h0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            wrenb = 1;
            in_data = 4'hA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'hA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            wrenb = 1;
            in_data = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            wrenb = 0;
            din = 1;
            #1;

            #1;


            check_outputs(1'b0, 4'h1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            wrenb = 0;
            din = 0;
            #1;

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            wrenb = 1;
            in_data = 4'h7;
            @(posedge clk);
            #1;

            wrenb = 0;
            din = 1;
            #1;

            #1;


            check_outputs(1'b0, 4'h1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;

            wrenb = 0;
            in_data = 4'hE;
            din = 0;
            @(posedge clk);
            #1;



            wrenb = 1;
            #1;

            #1;


            check_outputs(1'b1, 4'h0);
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
        input expected_hit;
        input [3:0] expected_out_data;
        begin
            if (expected_hit === (expected_hit ^ hit ^ expected_hit) &&
                expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: hit=%b, out_data=%h",
                         hit, out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hit=%b, out_data=%h",
                         expected_hit, expected_out_data);
                $display("  Got:      hit=%b, out_data=%h",
                         hit, out_data);
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
        $dumpvars(0,clk, din, in_data, wrenb, hit, out_data);
    end

endmodule
