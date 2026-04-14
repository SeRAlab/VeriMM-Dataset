`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr;
    reg clk;
    reg [31:0] din;
    reg we;
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
        addr <= 10'h0;
        din <= 32'h0;
        we <= 1'b1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write to addr 0 and read back", test_num);
        reset_dut();


        addr <= 10'h000;
        din <= 32'hA5A5_5A5A;
        we <= 1'b0;
        @(posedge clk);


        we <= 1'b1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hA5A5_5A5A);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write to boundary addr 1023 and read back", test_num);
        reset_dut();


        addr <= 10'd1023;
        din <= 32'hCAFE_BABE;
        we <= 1'b0;
        @(posedge clk);


        we <= 1'b1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hCAFE_BABE);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify dout is High-Z during write", test_num);
        reset_dut();

        addr <= 10'h010;
        din <= 32'h1234_5678;
        we <= 1'b0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'hzzzz_zzzz);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequential writes, then read specific address", test_num);
        reset_dut();


        addr <= 10'h001; din <= 32'h1111_1111; we <= 1'b0;
        @(posedge clk);

        addr <= 10'h002; din <= 32'h2222_2222; we <= 1'b0;
        @(posedge clk);

        addr <= 10'h001; we <= 1'b1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h1111_1111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overwrite data at address 50", test_num);
        reset_dut();


        addr <= 10'd50;
        din <= 32'hAAAA_BBBB;
        we <= 1'b0;
        @(posedge clk);


        addr <= 10'd50;
        din <= 32'hCCCC_DDDD;
        we <= 1'b0;
        @(posedge clk);


        we <= 1'b1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hCCCC_DDDD);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Address walking bit check", test_num);
        reset_dut();


        addr <= 10'h020;
        din <= 32'h5555_AAAA;
        we <= 1'b0;
        @(posedge clk);


        addr <= 10'h020;
        we <= 1'b1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h5555_AAAA);
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
        $dumpvars(0,addr, clk, din, we, dout);
    end

endmodule
