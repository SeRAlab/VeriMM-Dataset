`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [17:0] Din;
    reg [11:0] Raddr;
    reg [11:0] Waddr;
    reg Wclk;
    reg nRclk;
    wire [17:0] Dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Din(Din),
        .Raddr(Raddr),
        .Waddr(Waddr),
        .Wclk(Wclk),
        .nRclk(nRclk),
        .Dout(Dout)
    );

    // Clock generation (10ns period)
    initial begin
        Wclk = 0;
        forever #5 Wclk = ~Wclk;
    end

        task reset_dut;

    begin
        Din = 0;
        Waddr = 0;
        Raddr = 0;
        nRclk = 1;
        @(posedge Wclk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Write and Read", test_num);
        reset_dut();


        Waddr = 12'h001;
        Din = 18'h12345;
        @(posedge Wclk);
        #2;


        Raddr = 12'h001;
        #5 nRclk = 0;
        #2;

        #1;


        check_outputs(18'h12345);
        nRclk = 1;
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write and Read from Address 0xFFF", test_num);
        reset_dut();


        Waddr = 12'hFFF;
        Din = 18'h3FFFF;
        @(posedge Wclk);
        #2;


        Raddr = 12'hFFF;
        #5 nRclk = 0;
        #2;

        #1;


        check_outputs(18'h3FFFF);
        nRclk = 1;
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simultaneous Read and Write (Different Addr)", test_num);
        reset_dut();


        Waddr = 12'h00A;
        Din = 18'h0AAAA;
        @(posedge Wclk);
        #2;


        Waddr = 12'h00B;
        Din = 18'h0BBBB;
        Raddr = 12'h00A;


        #3 nRclk = 0;
        @(posedge Wclk);
        #2;

        #1;


        check_outputs(18'h0AAAA);
        nRclk = 1;
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data Persistence check", test_num);
        reset_dut();


        Waddr = 12'h100; Din = 18'h11111;
        @(posedge Wclk);
        #2;


        Waddr = 12'h200; Din = 18'h22222;
        @(posedge Wclk);
        #2;


        Raddr = 12'h100;
        #5 nRclk = 0;
        #2;

        #1;


        check_outputs(18'h11111);
        nRclk = 1;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary check (Address 0, Data 0)", test_num);
        reset_dut();


        Waddr = 12'h000;
        Din = 18'h00000;
        @(posedge Wclk);
        #2;


        Raddr = 12'h000;
        #5 nRclk = 0;
        #2;

        #1;


        check_outputs(18'h00000);
        nRclk = 1;
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
        input [17:0] expected_Dout;
        begin
            if (expected_Dout === (expected_Dout ^ Dout ^ expected_Dout)) begin
                $display("PASS");
                $display("  Outputs: Dout=%h",
                         Dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dout=%h",
                         expected_Dout);
                $display("  Got:      Dout=%h",
                         Dout);
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
        $dumpvars(0,Din, Raddr, Waddr, Wclk, nRclk, Dout);
    end

endmodule
