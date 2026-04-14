`timescale 1ns/1ps

module tcp_segmenter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg [15:0] mss;
    reg rst;
    wire [15:0] data_out;
    wire more_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmenter dut (
        .clk(clk),
        .data_in(data_in),
        .mss(mss),
        .rst(rst),
        .data_out(data_out),
        .more_data(more_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 32'h0;
            mss = 16'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: MSS=16, Data=0x12345678", test_num);
            reset_dut();
            data_in = 32'h12345678;
            mss = 16'd16;


            #1 #1;
 check_outputs(16'h1234, 1'b1);


            @(posedge clk);
            #1 #1;
 check_outputs(16'h5678, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: MSS=8, Data=0xAABBCCDD", test_num);
            reset_dut();
            data_in = 32'hAABBCCDD;
            mss = 16'd8;


            #1 #1;
 check_outputs(16'h00AA, 1'b1);


            @(posedge clk);
            #1 #1;
 check_outputs(16'h00BB, 1'b1);


            @(posedge clk);
            #1 #1;
 check_outputs(16'h00CC, 1'b1);


            @(posedge clk);
            #1 #1;
 check_outputs(16'h00DD, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: MSS=32 (Packet <= MSS)", test_num);
            reset_dut();
            data_in = 32'hDEADBEEF;
            mss = 16'd32;


            #1 #1;
 check_outputs(16'hDEAD, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: MSS=16, Data=0x0000FFFF", test_num);
            reset_dut();
            data_in = 32'h0000FFFF;
            mss = 16'd16;

            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000, 1'b1);

            @(posedge clk);
            #1 #1;
 check_outputs(16'hFFFF, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: MSS=4, Data=0x12345678", test_num);
            reset_dut();
            data_in = 32'h12345678;
            mss = 16'd4;


            #1 #1;
 check_outputs(16'h0001, 1'b1);
            repeat(6) @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0008, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tcp_segmenter Testbench");
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
        input [15:0] expected_data_out;
        input expected_more_data;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_more_data === (expected_more_data ^ more_data ^ expected_more_data)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, more_data=%b",
                         data_out, more_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, more_data=%b",
                         expected_data_out, expected_more_data);
                $display("  Got:      data_out=%h, more_data=%b",
                         data_out, more_data);
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
        $dumpvars(0,clk, data_in, mss, rst, data_out, more_data);
    end

endmodule
