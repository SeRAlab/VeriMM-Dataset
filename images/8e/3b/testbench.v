`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg clk;
    reg [3:0] din;
    reg en;
    reg we;
    wire [3:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .en(en),
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
            addr <= 0;
            din <= 0;
            en <= 0;
            we <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            addr <= 3'd3;
            din <= 4'hA;
            en <= 1;
            we <= 1;
            @(posedge clk);
            #1;


            we <= 0;
            @(posedge clk);
            #1;


            $display("Testcase %0d: Basic Write/Read", test_num);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            addr <= 3'd0;
            din <= 4'h5;
            en <= 1;
            we <= 1;
            @(posedge clk);
            #1;


            din <= 4'hF;
            @(posedge clk);
            #1;


            we <= 0;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Overwrite Data", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            addr <= 3'd7;
            din <= 4'hC;
            en <= 1;
            we <= 1;
            @(posedge clk);
            #1;


            addr <= 3'd1;
            din <= 4'h2;
            @(posedge clk);
            #1;


            addr <= 3'd7;
            we <= 0;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Multi-address Persistence", test_num);
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            addr <= 3'd4;
            din <= 4'h9;
            en <= 0;
            we <= 1;
            @(posedge clk);
            #1;


            en <= 1;
            we <= 0;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Enable Signal Check", test_num);

            if (dout !== 4'h9) begin
                pass_count = pass_count + 1;
                $display("PASS: Data 0x9 was not written because en=0");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Data was written despite en=0");
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            addr <= 3'd2;
            din <= 4'h3;
            en <= 1;
            we <= 1;
            @(posedge clk);
            #1;


            din <= 4'h7;
            we <= 0;
            @(posedge clk);
            #1;


            @(posedge clk);
            #1;

            $display("Testcase %0d: Write Enable Check", test_num);
            #1;

            check_outputs(4'h3);
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
        input [3:0] expected_dout;
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
        $dumpvars(0,addr, clk, din, en, we, dout);
    end

endmodule
