`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] addr_a;
    reg [3:0] addr_b;
    reg clk;
    reg [6:0] din_a;
    reg we_a;
    wire [13:0] dout_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_a(addr_a),
        .addr_b(addr_b),
        .clk(clk),
        .din_a(din_a),
        .we_a(we_a),
        .dout_b(dout_b)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr_a = 0;
            addr_b = 0;
            din_a = 0;
            we_a = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            addr_a = 5'd0;
            din_a = 7'h01;
            we_a = 1;


            @(posedge clk);
            addr_a = 5'd1;
            din_a = 7'h02;

            @(posedge clk);
            we_a = 0;


            addr_b = 4'd0;
            #1;

            #1;


            check_outputs(14'h0101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            addr_a = 5'd10;
            din_a = 7'h7A;
            we_a = 1;


            @(posedge clk);
            addr_a = 5'd11;
            din_a = 7'h05;

            @(posedge clk);
            we_a = 0;


            addr_b = 4'd5;
            #1;

            #1;


            check_outputs(14'h02FA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            addr_a = 5'd4;
            din_a = 7'h11;
            we_a = 1;
            @(posedge clk);
            addr_a = 5'd5;
            din_a = 7'h22;
            @(posedge clk);
            we_a = 0;


            @(posedge clk);
            addr_a = 5'd4;
            din_a = 7'hFF;
            we_a = 0;
            @(posedge clk);
            addr_a = 5'd5;
            din_a = 7'hEE;

            @(posedge clk);

            addr_b = 4'd2;
            #1;

            #1;


            check_outputs(14'h0911);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            addr_a = 5'd30;
            din_a = 7'h7F;
            we_a = 1;


            @(posedge clk);
            addr_a = 5'd31;
            din_a = 7'h40;

            @(posedge clk);
            we_a = 0;


            addr_b = 4'd15;
            #1;

            #1;


            check_outputs(14'h207F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            addr_a = 5'd0; din_a = 7'h0A; we_a = 1;
            @(posedge clk);
            addr_a = 5'd1; din_a = 7'h0B;
            @(posedge clk);


            addr_a = 5'd0; din_a = 7'h20;
            @(posedge clk);
            addr_a = 5'd1; din_a = 7'h30;
            @(posedge clk);
            we_a = 0;

            addr_b = 4'd0;
            #1;

            #1;


            check_outputs(14'h1820);
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
        input [13:0] expected_dout_b;
        begin
            if (expected_dout_b === (expected_dout_b ^ dout_b ^ expected_dout_b)) begin
                $display("PASS");
                $display("  Outputs: dout_b=%h",
                         dout_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout_b=%h",
                         expected_dout_b);
                $display("  Got:      dout_b=%h",
                         dout_b);
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
        $dumpvars(0,addr_a, addr_b, clk, din_a, we_a, dout_b);
    end

endmodule
