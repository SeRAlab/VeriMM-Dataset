`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg en;
    reg [7:0] in;
    reg rst;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .en(en),
        .in(in),
        .rst(rst),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        en = 0;
        forever #5 en = ~en;
    end

        task reset_dut;

        begin
            rst = 1;
            in = 0;
            @(posedge en);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Single byte 'A' (65)", test_num);
            reset_dut();
            in = 8'd65;
            @(posedge en);
            #1;


            #1;



            check_outputs(16'h4242);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Multi-byte sequence 'AB'", test_num);
            reset_dut();
            in = 8'd65; @(posedge en); #1;
            in = 8'd66; @(posedge en); #1;
            #1;

            check_outputs(16'hC684);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Modulo wrap-around for Sum A", test_num);
            reset_dut();
            in = 8'd255; @(posedge en); #1;


            in = 8'd255; @(posedge en); #1;


            #1;



            check_outputs(16'h0E09);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Modulo boundary (Sum becomes 0)", test_num);
            reset_dut();
            in = 8'd250; @(posedge en); #1;


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: String 'Wikipedia'", test_num);
            reset_dut();

            in = 87;  @(posedge en); #1;
            in = 105; @(posedge en); #1;
            in = 107; @(posedge en); #1;
            in = 105; @(posedge en); #1;
            in = 112; @(posedge en); #1;
            in = 101; @(posedge en); #1;
            in = 100; @(posedge en); #1;
            in = 105; @(posedge en); #1;
            in = 97;  @(posedge en); #1;

            #1;


            check_outputs(16'h40A7);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Re-reset and short sequence", test_num);
            reset_dut();
            in = 8'd32; @(posedge en); #1;

            #1;


            check_outputs(16'h2121);
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
        input [15:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,en, in, rst, out);
    end

endmodule
