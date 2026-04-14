`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] HADDR;
    reg [31:0] IPdata_out;
    reg clk;
    reg [31:0] in_data;
    reg ready;
    reg rst;
    wire [31:0] IPdata_in;
    wire [31:0] out_data;
    wire write;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .HADDR(HADDR),
        .IPdata_out(IPdata_out),
        .clk(clk),
        .in_data(in_data),
        .ready(ready),
        .rst(rst),
        .IPdata_in(IPdata_in),
        .out_data(out_data),
        .write(write)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            HADDR = 0;
            IPdata_out = 0;
            in_data = 0;
            ready = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Write Operation (HADDR[0]=0)", test_num);
            reset_dut();

            HADDR = 32'hFFFFFFFE;
            in_data = 32'hDEADBEEF;
            ready = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hDEADBEEF, 32'h0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Read Operation Ready (HADDR[0]=1, ready=1)", test_num);
            reset_dut();

            HADDR = 32'h00000001;
            IPdata_out = 32'hCAFEBABE;
            ready = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0, 32'hCAFEBABE, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Read Operation Hold (HADDR[0]=1, ready=0)", test_num);
            reset_dut();


            HADDR = 32'h00000001;
            IPdata_out = 32'h11112222;
            ready = 1;
            @(posedge clk);
            #2;


            IPdata_out = 32'hEEEEFFFF;
            ready = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h0, 32'h11112222, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mode Switching (Write then Read)", test_num);
            reset_dut();


            HADDR = 32'hA0A0A0A0;
            in_data = 32'h5555AAAA;
            @(posedge clk);
            #2;


            HADDR = 32'hA0A0A0A1;
            IPdata_out = 32'h12345678;
            ready = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h5555AAAA, 32'h12345678, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Continuous Write Operation", test_num);
            reset_dut();

            HADDR = 32'h00000004;
            in_data = 32'h11111111;
            @(posedge clk);
            #2;

            in_data = 32'h22222222;
            @(posedge clk);
            #2;

            in_data = 32'h33333333;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h33333333, 32'h0, 1'b1);
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
        input [31:0] expected_IPdata_in;
        input [31:0] expected_out_data;
        input expected_write;
        begin
            if (expected_IPdata_in === (expected_IPdata_in ^ IPdata_in ^ expected_IPdata_in) &&
                expected_out_data === (expected_out_data ^ out_data ^ expected_out_data) &&
                expected_write === (expected_write ^ write ^ expected_write)) begin
                $display("PASS");
                $display("  Outputs: IPdata_in=%h, out_data=%h, write=%b",
                         IPdata_in, out_data, write);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IPdata_in=%h, out_data=%h, write=%b",
                         expected_IPdata_in, expected_out_data, expected_write);
                $display("  Got:      IPdata_in=%h, out_data=%h, write=%b",
                         IPdata_in, out_data, write);
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
        $dumpvars(0,HADDR, IPdata_out, clk, in_data, ready, rst, IPdata_in, out_data, write);
    end

endmodule
