`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] addr;
    reg clk;
    reg [9:0] din;
    reg we;
    wire [9:0] dout;

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
            $display("Running Testcase%03d: Basic Write/Read...", test_num);
            reset_dut();


            we = 1; addr = 13'h0000; din = 10'h123;
            @(posedge clk); #1;


            we = 0; addr = 13'h0000;
            @(posedge clk); #1;

            #1;


            check_outputs(10'h123);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase%03d: Boundary Address Test...", test_num);
            reset_dut();


            we = 1; addr = 13'h1FFF; din = 10'h2AA;
            @(posedge clk); #1;


            we = 0; addr = 13'h1FFF;
            @(posedge clk); #1;

            #1;


            check_outputs(10'h2AA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase%03d: WE Disable Check...", test_num);
            reset_dut();


            we = 1; addr = 13'h0010; din = 10'h0F0;
            @(posedge clk); #1;


            we = 0; addr = 13'h0010; din = 10'h3FF;
            @(posedge clk); #1;


            addr = 13'h0010;
            @(posedge clk); #1;

            #1;


            check_outputs(10'h0F0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase%03d: Overwrite Test...", test_num);
            reset_dut();


            we = 1; addr = 13'h0ABC; din = 10'h055;
            @(posedge clk); #1;


            we = 1; addr = 13'h0ABC; din = 10'h3AA;
            @(posedge clk); #1;


            we = 0; addr = 13'h0ABC;
            @(posedge clk); #1;

            #1;


            check_outputs(10'h3AA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase%03d: MSB (Bit 9) Test...", test_num);
            reset_dut();


            we = 1; addr = 13'h0500; din = 10'h201;
            @(posedge clk); #1;


            we = 0; addr = 13'h0500;
            @(posedge clk); #1;



            #1;




            check_outputs(10'h201);
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
        input [9:0] expected_dout;
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
