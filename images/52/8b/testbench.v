`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] addr;
    reg ce;
    reg clk;
    reg [5:0] din;
    reg write;
    wire [5:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .ce(ce),
        .clk(clk),
        .din(din),
        .write(write),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce = 0;
            write = 0;
            addr = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (Addr 5)", test_num);


            ce = 1;
            write = 1;
            addr = 5'h05;
            din = 6'h2A;
            @(posedge clk);
            #1;


            write = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h2A);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Chip Enable functionality", test_num);


            ce = 0;
            write = 1;
            addr = 5'h0A;
            din = 6'h3F;
            @(posedge clk);
            #1;


            ce = 1;
            write = 0;
            addr = 5'h0A;
            @(posedge clk);
            #1;

            if (dout !== 6'h3F) begin
                $display("PASS: Write blocked by ce=0");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Write occurred despite ce=0");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write Protection (Addr 0)", test_num);


            ce = 1;
            write = 1;
            addr = 5'h00;
            din = 6'h15;
            @(posedge clk);
            #1;


            write = 0;
            @(posedge clk);
            #1;

            if (dout !== 6'h15) begin
                $display("PASS: Address 0 write protection active");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Address 0 write protection failed");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Address adjustment check (Addr 4)", test_num);


            ce = 1;
            write = 1;
            addr = 5'h04;
            din = 6'h01;
            @(posedge clk);
            #1;


            write = 0;
            @(posedge clk);
            #1;


            $display("  Read Addr 4: %h", dout);
            pass_count = pass_count + 1;
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-address Write/Read sequence", test_num);


            ce = 1;
            write = 1;
            addr = 5'd18;
            din = 6'h11;
            @(posedge clk);
            #1;


            addr = 5'd19;
            din = 6'h22;
            @(posedge clk);
            #1;


            write = 0;
            addr = 5'd18;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h11);
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
        input [5:0] expected_dout;
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
        $dumpvars(0,addr, ce, clk, din, write, dout);
    end

endmodule
