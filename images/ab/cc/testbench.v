`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr;
    reg clk;
    reg [31:0] din;
    reg [3:0] enb;
    reg [3:0] web;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .enb(enb),
        .web(web),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr <= 0;
            din <= 0;
            enb <= 4'b0000;
            web <= 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            addr <= 10'h010;
            din <= 32'hDEADBEEF;
            enb <= 4'b1111;
            web <= 4'b1111;
            @(posedge clk);


            #1;
            web <= 4'b0000;
            @(posedge clk);

            #1;
            $display("Testcase %0d: Full Word Write/Read", test_num);
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            addr <= 10'h020;
            din <= 32'h00000000;
            enb <= 4'b1111;
            web <= 4'b1111;
            @(posedge clk);


            #1;
            din <= 32'hFFFFABCD;
            web <= 4'b0011;
            @(posedge clk);


            #1;
            web <= 4'b0000;
            @(posedge clk);

            #1;
            $display("Testcase %0d: Byte-wise Write (Lower 16 bits)", test_num);
            #1;

            check_outputs(32'h0000ABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            addr <= 10'h030;
            din <= 32'h12340000;
            enb <= 4'b1111;
            web <= 4'b1100;
            @(posedge clk);


            #1;
            web <= 4'b0000;
            @(posedge clk);

            #1;
            $display("Testcase %0d: Byte-wise Write (Upper 16 bits)", test_num);
            #1;

            check_outputs(32'h12340000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            addr <= 10'h040;
            din <= 32'h55555555;
            enb <= 4'b0000;
            web <= 4'b1111;
            @(posedge clk);



            #1;
            enb <= 4'b1111;
            web <= 4'b0000;
            @(posedge clk);

            #1;
            $display("Testcase %0d: Verify enb=0 prevents writing", test_num);
            if (dout !== 32'h55555555) begin
                pass_count = pass_count + 1;
                $display("PASS: Data was not written");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Data was written despite enb=0");
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            addr <= 10'h0A1;
            din <= 32'hAAAA_AAAA;
            enb <= 4'b1111;
            web <= 4'b1111;
            @(posedge clk);


            #1;
            addr <= 10'h0B2;
            din <= 32'hBBBB_BBBB;
            @(posedge clk);


            #1;
            addr <= 10'h0A1;
            web <= 4'b0000;
            @(posedge clk);

            #1;
            $display("Testcase %0d: Multi-address Persistence", test_num);
            #1;

            check_outputs(32'hAAAA_AAAA);
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
        input [31:0] expected_dout;
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
        $dumpvars(0,addr, clk, din, enb, web, dout);
    end

endmodule
