`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst;
    reg [31:0] src_ip;
    reg [15:0] src_port;
    wire [31:0] translated_ip;
    wire [15:0] translated_port;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .clk(clk),
        .enable(enable),
        .rst(rst),
        .src_ip(src_ip),
        .src_port(src_port),
        .translated_ip(translated_ip),
        .translated_port(translated_port),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        enable = 0;
        src_ip = 32'h0;
        src_port = 16'h0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Valid Mapping Hit (Entry 1)", test_num);
        reset_dut();

        src_ip = 32'hC0A80101;
        src_port = 16'h0050;
        enable = 1;

        @(posedge clk);
        #1;
        enable = 0;


        #1;



        check_outputs(32'h0A000001, 16'h1F90, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Valid Mapping Hit (Entry 2)", test_num);
        reset_dut();

        src_ip = 32'hC0A80102;
        src_port = 16'h01BB;
        enable = 1;

        @(posedge clk);
        #1;
        enable = 0;


        #1;



        check_outputs(32'h0A000002, 16'h20FB, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Mapping Miss (Non-existent Entry)", test_num);
        reset_dut();

        src_ip = 32'hFFFFFFFF;
        src_port = 16'hFFFF;
        enable = 1;

        @(posedge clk);
        #1;
        enable = 0;




        #1;





        check_outputs(translated_ip, translated_port, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Enable Deasserted", test_num);
        reset_dut();

        src_ip = 32'hC0A80101;
        src_port = 16'h0050;
        enable = 0;

        @(posedge clk);
        #1;


        #1;



        check_outputs(translated_ip, translated_port, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Consecutive Operations", test_num);
        reset_dut();


        src_ip = 32'hC0A80101;
        src_port = 16'h0050;
        enable = 1;
        @(posedge clk);
        #1;


        src_ip = 32'hC0A80102;
        src_port = 16'h01BB;
        enable = 1;
        @(posedge clk);
        #1;
        enable = 0;


        #1;



        check_outputs(32'h0A000002, 16'h20FB, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NAT Testbench");
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
        input [31:0] expected_translated_ip;
        input [15:0] expected_translated_port;
        input expected_valid;
        begin
            if (expected_translated_ip === (expected_translated_ip ^ translated_ip ^ expected_translated_ip) &&
                expected_translated_port === (expected_translated_port ^ translated_port ^ expected_translated_port) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: translated_ip=%h, translated_port=%h, valid=%b",
                         translated_ip, translated_port, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: translated_ip=%h, translated_port=%h, valid=%b",
                         expected_translated_ip, expected_translated_port, expected_valid);
                $display("  Got:      translated_ip=%h, translated_port=%h, valid=%b",
                         translated_ip, translated_port, valid);
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
        $dumpvars(0,clk, enable, rst, src_ip, src_port, translated_ip, translated_port, valid);
    end

endmodule
