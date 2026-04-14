`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] r1;
    reg [4:0] r2;
    reg [4:0] r3;
    reg rst;
    reg [4:0] w1;
    reg [31:0] wdata;
    reg wea;
    wire [31:0] out1;
    wire [31:0] out2;
    wire [31:0] out3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .r1(r1),
        .r2(r2),
        .r3(r3),
        .rst(rst),
        .w1(w1),
        .wdata(wdata),
        .wea(wea),
        .out1(out1),
        .out2(out2),
        .out3(out3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            wea = 0;
            w1 = 0;
            wdata = 0;
            r1 = 0;
            r2 = 0;
            r3 = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read", test_num);

            @(negedge clk);
            wea = 1;
            w1 = 5'd5;
            wdata = 32'hAAAA_5555;

            @(posedge clk);
            #1 wea = 0;
            r1 = 5'd5;
            r2 = 5'd5;
            r3 = 5'd5;

            #1;
            #1;

            check_outputs(32'hAAAA_5555, 32'hAAAA_5555, 32'hAAAA_5555);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Multiple Registers and Ports", test_num);


            @(negedge clk);
            wea = 1; w1 = 5'd10; wdata = 32'h1111_1111;
            @(posedge clk);


            @(negedge clk);
            wea = 1; w1 = 5'd20; wdata = 32'h2222_2222;
            @(posedge clk);


            @(negedge clk);
            wea = 1; w1 = 5'd30; wdata = 32'h3333_3333;
            @(posedge clk);

            #1 wea = 0;
            r1 = 5'd10;
            r2 = 5'd20;
            r3 = 5'd30;

            #1;
            #1;

            check_outputs(32'h1111_1111, 32'h2222_2222, 32'h3333_3333);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Write Enable Check", test_num);

            @(negedge clk);
            wea = 0;
            w1 = 5'd15;
            wdata = 32'hFFFF_FFFF;

            @(posedge clk);
            #1 r1 = 5'd15;
            r2 = 0;
            r3 = 0;

            #1;

            #1;


            check_outputs(32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Overwriting Data", test_num);

            @(negedge clk);
            wea = 1; w1 = 5'd7; wdata = 32'h1234_5678;
            @(posedge clk);

            @(negedge clk);
            wea = 1; w1 = 5'd7; wdata = 32'h8765_4321;
            @(posedge clk);

            #1 wea = 0;
            r1 = 5'd7;
            r2 = 0;
            r3 = 0;

            #1;
            #1;

            check_outputs(32'h8765_4321, 32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Boundary Registers", test_num);

            @(negedge clk);
            wea = 1; w1 = 5'd0; wdata = 32'h0000_0001;
            @(posedge clk);

            @(negedge clk);
            wea = 1; w1 = 5'd31; wdata = 32'h8000_0000;
            @(posedge clk);

            #1 wea = 0;
            r1 = 5'd0;
            r2 = 5'd31;
            r3 = 5'd0;

            #1;


            #1;



            check_outputs(out1, 32'h8000_0000, out1);
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
        input [31:0] expected_out1;
        input [31:0] expected_out2;
        input [31:0] expected_out3;
        begin
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h, out3=%h",
                         out1, out2, out3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h, out3=%h",
                         expected_out1, expected_out2, expected_out3);
                $display("  Got:      out1=%h, out2=%h, out3=%h",
                         out1, out2, out3);
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
        $dumpvars(0,clk, r1, r2, r3, rst, w1, wdata, wea, out1, out2, out3);
    end

endmodule
