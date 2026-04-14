`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] allowed_dst_ip;
    reg [7:0] allowed_src_ip;
    reg clk;
    reg [7:0] dst_ip;
    reg rst;
    reg [7:0] src_ip;
    wire allowed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .allowed_dst_ip(allowed_dst_ip),
        .allowed_src_ip(allowed_src_ip),
        .clk(clk),
        .dst_ip(dst_ip),
        .rst(rst),
        .src_ip(src_ip),
        .allowed(allowed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        allowed_dst_ip = 8'd0;
        allowed_src_ip = 8'd0;
        dst_ip = 8'd0;
        src_ip = 8'd0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: Exact Match", test_num);
        allowed_src_ip = 8'hA5;
        allowed_dst_ip = 8'h5A;
        src_ip = 8'hA5;
        dst_ip = 8'h5A;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: Source IP Mismatch", test_num);
        allowed_src_ip = 8'hA5;
        allowed_dst_ip = 8'h5A;
        src_ip = 8'hFF;
        dst_ip = 8'h5A;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: Destination IP Mismatch", test_num);
        allowed_src_ip = 8'hA5;
        allowed_dst_ip = 8'h5A;
        src_ip = 8'hA5;
        dst_ip = 8'h00;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: Both IP Mismatch", test_num);
        allowed_src_ip = 8'h11;
        allowed_dst_ip = 8'h22;
        src_ip = 8'h33;
        dst_ip = 8'h44;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: Boundary Condition All Zeros", test_num);
        allowed_src_ip = 8'h00;
        allowed_dst_ip = 8'h00;
        src_ip = 8'h00;
        dst_ip = 8'h00;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: Boundary Condition All Ones", test_num);
        allowed_src_ip = 8'hFF;
        allowed_dst_ip = 8'hFF;
        src_ip = 8'hFF;
        dst_ip = 8'hFF;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: Rule change check", test_num);

        allowed_src_ip = 8'h10;
        allowed_dst_ip = 8'h20;
        src_ip = 8'h10;
        dst_ip = 8'h20;
        @(posedge clk);

        allowed_src_ip = 8'hCC;
        allowed_dst_ip = 8'hDD;
        src_ip = 8'h10;
        dst_ip = 8'h20;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
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
        input expected_allowed;
        begin
            if (expected_allowed === (expected_allowed ^ allowed ^ expected_allowed)) begin
                $display("PASS");
                $display("  Outputs: allowed=%b",
                         allowed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allowed=%b",
                         expected_allowed);
                $display("  Got:      allowed=%b",
                         allowed);
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
        $dumpvars(0,allowed_dst_ip, allowed_src_ip, clk, dst_ip, rst, src_ip, allowed);
    end

endmodule
