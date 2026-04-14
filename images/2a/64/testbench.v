`timescale 1ns/1ps

module nat_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] ip_in;
    reg [15:0] port_in;
    reg reset;
    wire [31:0] ip_out;
    wire [15:0] port_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat_module dut (
        .clk(clk),
        .ip_in(ip_in),
        .port_in(port_in),
        .reset(reset),
        .ip_out(ip_out),
        .port_out(port_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ip_in = 32'd0;
            port_in = 16'd0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mapping 1 (192.168.1.1:80)", test_num);
            reset_dut();
            ip_in = 32'hC0A80101;
            port_in = 16'h0050;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0A000001, 16'h1F90);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mapping 2 (192.168.1.2:443)", test_num);
            reset_dut();
            ip_in = 32'hC0A80102;
            port_in = 16'h01BB;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0A000001, 16'h1F91);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mapping 3 (192.168.1.3:22)", test_num);
            reset_dut();
            ip_in = 32'hC0A80103;
            port_in = 16'h0016;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0A000001, 16'h1F92);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mapping 4 (192.168.1.4:53)", test_num);
            reset_dut();
            ip_in = 32'hC0A80104;
            port_in = 16'h0035;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0A000001, 16'h1F93);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mapping 5 (192.168.1.5:21)", test_num);
            reset_dut();
            ip_in = 32'hC0A80105;
            port_in = 16'h0015;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0A000001, 16'h1F94);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No Mapping (Correct IP, Wrong Port)", test_num);
            reset_dut();
            ip_in = 32'hC0A80101;
            port_in = 16'hFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No Mapping (Unknown IP/Port)", test_num);
            reset_dut();
            ip_in = 32'h08080808;
            port_in = 16'h1234;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000, 16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [31:0] expected_ip_out;
        input [15:0] expected_port_out;
        begin
            if (expected_ip_out === (expected_ip_out ^ ip_out ^ expected_ip_out) &&
                expected_port_out === (expected_port_out ^ port_out ^ expected_port_out)) begin
                $display("PASS");
                $display("  Outputs: ip_out=%h, port_out=%h",
                         ip_out, port_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ip_out=%h, port_out=%h",
                         expected_ip_out, expected_port_out);
                $display("  Got:      ip_out=%h, port_out=%h",
                         ip_out, port_out);
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
        $dumpvars(0,clk, ip_in, port_in, reset, ip_out, port_out);
    end

endmodule
