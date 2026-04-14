`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [63:0] wdata;
    reg we;
    wire [63:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .wdata(wdata),
        .we(we),
        .rdata(rdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            we = 0;
            wdata = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read at 0x01", test_num);


            addr = 8'h01;
            wdata = 64'h0123456789ABCDEF;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            addr = 8'h01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'h0123456789ABCDEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Address 0xFF", test_num);


            addr = 8'hFF;
            wdata = 64'hFEDCBA9876543210;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            addr = 8'hFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable (we) validation", test_num);


            addr = 8'h55;
            wdata = 64'hAAAA_AAAA_AAAA_AAAA;
            we = 1;
            @(posedge clk);
            #1;


            addr = 8'h55;
            wdata = 64'h5555_5555_5555_5555;
            we = 0;
            @(posedge clk);
            #1;


            addr = 8'h55;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'hAAAA_AAAA_AAAA_AAAA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Overwriting memory location", test_num);


            addr = 8'hA0;
            wdata = 64'h1111_2222_3333_4444;
            we = 1;
            @(posedge clk);
            #1;


            addr = 8'hA0;
            wdata = 64'h5555_6666_7777_8888;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            addr = 8'hA0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'h5555_6666_7777_8888);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Zero Address check", test_num);


            addr = 8'h00;
            wdata = 64'hDEAD_BEEF_CAFE_BABE;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            addr = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'hDEAD_BEEF_CAFE_BABE);
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
        input [63:0] expected_rdata;
        begin
            if (expected_rdata === (expected_rdata ^ rdata ^ expected_rdata)) begin
                $display("PASS");
                $display("  Outputs: rdata=%h",
                         rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata=%h",
                         expected_rdata);
                $display("  Got:      rdata=%h",
                         rdata);
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
        $dumpvars(0,addr, clk, wdata, we, rdata);
    end

endmodule
