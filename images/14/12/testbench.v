`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] external_ip;
    reg [15:0] external_port;
    reg [31:0] internal_ip;
    reg [15:0] internal_port;
    reg [1:0] op_mode;
    reg rst;
    wire [31:0] out_ip;
    wire [15:0] out_port;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .clk(clk),
        .external_ip(external_ip),
        .external_port(external_port),
        .internal_ip(internal_ip),
        .internal_port(internal_port),
        .op_mode(op_mode),
        .rst(rst),
        .out_ip(out_ip),
        .out_port(out_port),
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
        external_ip = 0;
        external_port = 0;
        internal_ip = 0;
        internal_port = 0;
        op_mode = 2'b00;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Internal to External Mapping...");
        reset_dut();
        internal_ip = 32'hC0A80105;
        internal_port = 16'h1F40;
        external_ip = 32'h08080808;
        external_port = 16'h0050;
        op_mode = 2'b00;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h08080808, 16'h0050, 1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Undoing Mapping (External to Internal)...");
        reset_dut();
        internal_ip = 32'hC0A8010A;
        internal_port = 16'h04D2;
        external_ip = 32'h42660101;
        external_port = 16'h01BB;
        op_mode = 2'b01;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hC0A8010A, 16'h04D2, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Pass Traffic Through...");
        reset_dut();
        internal_ip = 32'h0A000001;
        internal_port = 16'hFFFF;
        external_ip = 32'hDEADC0DE;
        external_port = 16'hBEEF;
        op_mode = 2'b10;

        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h0A000001, 16'hFFFF, 1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Invalid Mode (11)...");
        reset_dut();
        internal_ip = 32'hFFFFFFFF;
        internal_port = 16'hFFFF;
        op_mode = 2'b11;

        @(posedge clk);
        #1;

        #1;


        check_outputs(out_ip, out_port, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Reset State...");
        reset_dut();

        rst = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(out_ip, out_port, 1'b0);
        rst = 0;
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Internal to External - Alternative IPs...");
        reset_dut();
        internal_ip = 32'h7F000001;
        internal_port = 16'h3039;
        external_ip = 32'h01010101;
        external_port = 16'h0035;
        op_mode = 2'b00;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h01010101, 16'h0035, 1'b1);
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
        input [31:0] expected_out_ip;
        input [15:0] expected_out_port;
        input expected_valid;
        begin
            if (expected_out_ip === (expected_out_ip ^ out_ip ^ expected_out_ip) &&
                expected_out_port === (expected_out_port ^ out_port ^ expected_out_port) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: out_ip=%h, out_port=%h, valid=%b",
                         out_ip, out_port, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_ip=%h, out_port=%h, valid=%b",
                         expected_out_ip, expected_out_port, expected_valid);
                $display("  Got:      out_ip=%h, out_port=%h, valid=%b",
                         out_ip, out_port, valid);
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
        $dumpvars(0,clk, external_ip, external_port, internal_ip, internal_port, op_mode, rst, out_ip, out_port, valid);
    end

endmodule
