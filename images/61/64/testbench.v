`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr;
    reg hclk;
    reg hresetn;
    reg ready;
    wire hsel0;
    wire hsel0_rd;
    wire hsel1;
    wire hsel1_rd;
    wire hsel2;
    wire hsel2_rd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .hclk(hclk),
        .hresetn(hresetn),
        .ready(ready),
        .hsel0(hsel0),
        .hsel0_rd(hsel0_rd),
        .hsel1(hsel1),
        .hsel1_rd(hsel1_rd),
        .hsel2(hsel2),
        .hsel2_rd(hsel2_rd)
    );

    // Clock generation (10ns period)
    initial begin
        hclk = 0;
        forever #5 hclk = ~hclk;
    end

        task reset_dut;

        begin
            hclk = 0;
            hresetn = 0;
            addr = 32'h0;
            ready = 0;
            #10;
            hresetn = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();



            #1;




            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select 0 (Address 0x0000_0000, Ready=1)", test_num);
            reset_dut();
            @(posedge hclk);
            addr = 32'h0ABC_DEF0;
            ready = 1;
            @(posedge hclk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select 1 (Address 0x1000_0000, Ready=1)", test_num);
            reset_dut();
            @(posedge hclk);
            addr = 32'h1000_0000;
            ready = 1;
            @(posedge hclk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select 1 (Address 0x2FFF_FFFF, Ready=1)", test_num);
            reset_dut();
            @(posedge hclk);
            addr = 32'h2FFF_FFFF;
            ready = 1;
            @(posedge hclk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select 1 (Address 0x3000_1234, Ready=1)", test_num);
            reset_dut();
            @(posedge hclk);
            addr = 32'h3000_1234;
            ready = 1;
            @(posedge hclk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select 2 (Address 0x4000_0000, Ready=1)", test_num);
            reset_dut();
            @(posedge hclk);
            addr = 32'h4000_0000;
            ready = 1;
            @(posedge hclk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select 2 (Address 0xF000_0000, Ready=1)", test_num);
            reset_dut();
            @(posedge hclk);
            addr = 32'hF000_0000;
            ready = 1;
            @(posedge hclk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Ready Signal Gating (Change address while Ready=0)", test_num);
            reset_dut();


            @(posedge hclk);
            addr = 32'h0000_0000;
            ready = 1;
            @(posedge hclk);
            #1;



            addr = 32'h1000_0000;
            ready = 0;
            @(posedge hclk);
            #1;


            #1;



            check_outputs(1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Transitions", test_num);
            reset_dut();


            @(posedge hclk);
            addr = 32'h5555_5555;
            ready = 1;
            @(posedge hclk);


            addr = 32'h2000_0000;
            ready = 1;
            @(posedge hclk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0);
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
        testcase008();
        testcase009();
        
        
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
        input expected_hsel0;
        input expected_hsel0_rd;
        input expected_hsel1;
        input expected_hsel1_rd;
        input expected_hsel2;
        input expected_hsel2_rd;
        begin
            if (expected_hsel0 === (expected_hsel0 ^ hsel0 ^ expected_hsel0) &&
                expected_hsel0_rd === (expected_hsel0_rd ^ hsel0_rd ^ expected_hsel0_rd) &&
                expected_hsel1 === (expected_hsel1 ^ hsel1 ^ expected_hsel1) &&
                expected_hsel1_rd === (expected_hsel1_rd ^ hsel1_rd ^ expected_hsel1_rd) &&
                expected_hsel2 === (expected_hsel2 ^ hsel2 ^ expected_hsel2) &&
                expected_hsel2_rd === (expected_hsel2_rd ^ hsel2_rd ^ expected_hsel2_rd)) begin
                $display("PASS");
                $display("  Outputs: hsel0=%b, hsel0_rd=%b, hsel1=%b, hsel1_rd=%b, hsel2=%b, hsel2_rd=%b",
                         hsel0, hsel0_rd, hsel1, hsel1_rd, hsel2, hsel2_rd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hsel0=%b, hsel0_rd=%b, hsel1=%b, hsel1_rd=%b, hsel2=%b, hsel2_rd=%b",
                         expected_hsel0, expected_hsel0_rd, expected_hsel1, expected_hsel1_rd, expected_hsel2, expected_hsel2_rd);
                $display("  Got:      hsel0=%b, hsel0_rd=%b, hsel1=%b, hsel1_rd=%b, hsel2=%b, hsel2_rd=%b",
                         hsel0, hsel0_rd, hsel1, hsel1_rd, hsel2, hsel2_rd);
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
        $dumpvars(0,addr, hclk, hresetn, ready, hsel0, hsel0_rd, hsel1, hsel1_rd, hsel2, hsel2_rd);
    end

endmodule
