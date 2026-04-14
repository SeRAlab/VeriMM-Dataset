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
            din  <= 0;
            enb  <= 4'b0000;
            web  <= 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Full Word Write/Read", test_num);


            @(posedge clk);
            addr <= 10'h000;
            din  <= 32'hDEADBEEF;
            enb  <= 4'b1111;
            web  <= 4'b1111;


            @(posedge clk);
            web  <= 4'b0000;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Independent Byte Writes", test_num);


            @(posedge clk);
            addr <= 10'h005;
            din  <= 32'h00000000;
            enb  <= 4'b1111;
            web  <= 4'b1111;


            @(posedge clk);
            din  <= 32'h00000011;
            web  <= 4'b0001;


            @(posedge clk);
            din  <= 32'h00220000;
            web  <= 4'b0100;


            @(posedge clk);
            web  <= 4'b0000;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00220011);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: enb Control Logic (Write Disable)", test_num);


            @(posedge clk);
            addr <= 10'h010;
            din  <= 32'hAAAA_AAAA;
            enb  <= 4'b1111;
            web  <= 4'b1111;


            @(posedge clk);
            din  <= 32'h5555_5555;
            enb  <= 4'b0000;
            web  <= 4'b1111;


            @(posedge clk);
            enb  <= 4'b1111;
            web  <= 4'b0000;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Partial Word Enable", test_num);


            @(posedge clk);
            addr <= 10'h020;
            din  <= 32'h12345678;
            enb  <= 4'b1111;
            web  <= 4'b1111;


            @(posedge clk);
            din  <= 32'h9ABC_0000;
            enb  <= 4'b1111;
            web  <= 4'b1100;


            @(posedge clk);
            web  <= 4'b0000;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h9ABC5678);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Address Independence", test_num);


            @(posedge clk);
            addr <= 10'h0A;
            din  <= 32'hA1A1A1A1;
            enb  <= 4'b1111;
            web  <= 4'b1111;


            @(posedge clk);
            addr <= 10'h0B;
            din  <= 32'hB2B2B2B2;


            @(posedge clk);
            addr <= 10'h0A;
            web  <= 4'b0000;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hA1A1A1A1);
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
