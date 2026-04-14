`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] addr;
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
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            we = 1;
            addr = 13'd100;
            din = 12'hABC;
            @(posedge clk);
            #1;



            we = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Check - Address 0", test_num);
            reset_dut();

            we = 1;
            addr = 13'd0;
            din = 12'hFFF;
            @(posedge clk);
            #1;

            we = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Check - Address 5777", test_num);
            reset_dut();

            we = 1;
            addr = 13'd5777;
            din = 12'h555;
            @(posedge clk);
            #1;

            we = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify WE functionality (WE=0)", test_num);
            reset_dut();


            we = 1;
            addr = 13'd250;
            din = 12'hAAA;
            @(posedge clk);
            #1;


            we = 0;
            addr = 13'd250;
            din = 12'hBBB;
            @(posedge clk);
            #1;


            #1;



            check_outputs(12'hAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite memory location", test_num);
            reset_dut();


            we = 1;
            addr = 13'd1024;
            din = 12'h111;
            @(posedge clk);
            #1;


            we = 1;
            addr = 13'd1024;
            din = 12'h222;
            @(posedge clk);
            #1;


            we = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h222);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Persistence across multiple addresses", test_num);
            reset_dut();


            we = 1;
            addr = 13'd10;
            din = 12'h010;
            @(posedge clk);
            #1;


            we = 1;
            addr = 13'd20;
            din = 12'h020;
            @(posedge clk);
            #1;


            we = 0;
            addr = 13'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h010);
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
