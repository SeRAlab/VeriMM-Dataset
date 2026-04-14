`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr;
    reg clk;
    reg [11:0] din;
    reg we;
    wire [11:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .we(we),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            addr = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: Basic Write and Read", test_num);


            @(posedge clk);
            addr = 10'd100;
            din = 12'hA5A;
            we = 1;
            @(posedge clk);
            we = 0;


            #1;
            addr = 10'd100;
            #2;
            #1;

            check_outputs(12'hA5A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: Boundary Address (Max)", test_num);


            @(posedge clk);
            addr = 10'd1023;
            din = 12'hFFF;
            we = 1;
            @(posedge clk);
            we = 0;


            #1;
            addr = 10'd1023;
            #2;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: Boundary Address (Min)", test_num);


            @(posedge clk);
            addr = 10'd0;
            din = 12'h001;
            we = 1;
            @(posedge clk);
            we = 0;


            #1;
            addr = 10'd0;
            #2;
            #1;

            check_outputs(12'h001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: Write Enable Verification", test_num);


            @(posedge clk);
            addr = 10'd50;
            din = 12'h123;
            we = 1;
            @(posedge clk);


            we = 0;
            din = 12'hBAD;
            @(posedge clk);


            #1;
            addr = 10'd50;
            #2;
            #1;

            check_outputs(12'h123);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: Overwriting Data", test_num);


            @(posedge clk);
            addr = 10'd256;
            din = 12'hAAA;
            we = 1;
            @(posedge clk);


            din = 12'h555;
            @(posedge clk);
            we = 0;


            #1;
            addr = 10'd256;
            #2;
            #1;

            check_outputs(12'h555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %03d: Multiple Sequential Operations", test_num);


            @(posedge clk);
            we = 1;
            addr = 10'd10; din = 12'h111; @(posedge clk);
            addr = 10'd11; din = 12'h222; @(posedge clk);
            addr = 10'd12; din = 12'h333; @(posedge clk);
            we = 0;


            #1;
            addr = 10'd11;
            #2;
            #1;

            check_outputs(12'h222);
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
        input [11:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
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
        $dumpvars(0,addr, clk, din, we, dout);
    end

endmodule
