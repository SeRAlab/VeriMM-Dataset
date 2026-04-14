`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] dst_ip;
    reg [15:0] dst_port;
    reg rst;
    reg [31:0] src_ip;
    wire accept;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .clk(clk),
        .dst_ip(dst_ip),
        .dst_port(dst_port),
        .rst(rst),
        .src_ip(src_ip),
        .accept(accept)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            src_ip = 0;
            dst_ip = 0;
            dst_port = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Valid packet - Lower boundary (192.168.1.1, Port 80)", test_num);
            src_ip = {8'd192, 8'd168, 8'd1, 8'd1};
            dst_ip = {8'd10, 8'd0, 8'd0, 8'd5};
            dst_port = 16'd80;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Valid packet - Upper boundary (192.168.1.10, Port 80)", test_num);
            src_ip = {8'd192, 8'd168, 8'd1, 8'd10};
            dst_ip = {8'd10, 8'd0, 8'd0, 8'd5};
            dst_port = 16'd80;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Invalid packet - Wrong Port (Port 443)", test_num);
            src_ip = {8'd192, 8'd168, 8'd1, 8'd5};
            dst_ip = {8'd10, 8'd0, 8'd0, 8'd5};
            dst_port = 16'd443;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Invalid packet - IP below range (192.168.1.0)", test_num);
            src_ip = {8'd192, 8'd168, 8'd1, 8'd0};
            dst_ip = {8'd10, 8'd0, 8'd0, 8'd5};
            dst_port = 16'd80;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Invalid packet - IP above range (192.168.1.11)", test_num);
            src_ip = {8'd192, 8'd168, 8'd1, 8'd11};
            dst_ip = {8'd10, 8'd0, 8'd0, 8'd5};
            dst_port = 16'd80;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Invalid packet - Wrong Subnet (10.0.0.1)", test_num);
            src_ip = {8'd10, 8'd0, 8'd0, 8'd1};
            dst_ip = {8'd10, 8'd0, 8'd0, 8'd5};
            dst_port = 16'd80;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Sequential - Reset check", test_num);

            src_ip = {8'd192, 8'd168, 8'd1, 8'd5};
            dst_port = 16'd80;
            @(posedge clk);
            #1;

            rst = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
            rst = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("packet_filter Testbench");
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
        input expected_accept;
        begin
            if (expected_accept === (expected_accept ^ accept ^ expected_accept)) begin
                $display("PASS");
                $display("  Outputs: accept=%b",
                         accept);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: accept=%b",
                         expected_accept);
                $display("  Got:      accept=%b",
                         accept);
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
        $dumpvars(0,clk, dst_ip, dst_port, rst, src_ip, accept);
    end

endmodule
