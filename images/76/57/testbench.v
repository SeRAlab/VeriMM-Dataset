`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [17:0] din;
    reg we;
    wire [17:0] dout;

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
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Basic Write and Read", test_num);


        addr = 8'h05;
        din  = 18'h12345;
        we   = 1;
        @(posedge clk);
        #1;


        we   = 0;
        addr = 8'h05;
        @(posedge clk);
        #1;

        #1;


        check_outputs(18'h12345);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Boundary Address 0xFF", test_num);


        addr = 8'hFF;
        din  = 18'h3FFFF;
        we   = 1;
        @(posedge clk);
        #1;


        we   = 0;
        addr = 8'hFF;
        @(posedge clk);
        #1;

        #1;


        check_outputs(18'h3FFFF);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Write Enable De-assertion", test_num);


        addr = 8'h20;
        din  = 18'h0AAAA;
        we   = 1;
        @(posedge clk);
        #1;


        we   = 0;
        din  = 18'h35555;
        @(posedge clk);
        #1;


        addr = 8'h20;
        @(posedge clk);
        #1;

        #1;


        check_outputs(18'h0AAAA);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Consecutive Writes", test_num);


        addr = 8'd10; din = 18'h11111; we = 1;
        @(posedge clk); #1;


        addr = 8'd11; din = 18'h22222; we = 1;
        @(posedge clk); #1;


        we = 0; addr = 8'd10;
        @(posedge clk); #1;


        #1;



        check_outputs(18'h11111);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Checkerboard Pattern", test_num);

        addr = 8'hAA;
        din  = 18'h2AAAA;
        we   = 1;
        @(posedge clk);
        #1;

        we   = 0;
        addr = 8'hAA;
        @(posedge clk);
        #1;

        #1;


        check_outputs(18'h2AAAA);
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
        input [17:0] expected_dout;
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
