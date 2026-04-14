`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg hd_a;
    reg hd_b;
    reg nrst;
    reg start;
    reg vin;
    wire [7:0] dout;
    wire vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .hd_a(hd_a),
        .hd_b(hd_b),
        .nrst(nrst),
        .start(start),
        .vin(vin),
        .dout(dout),
        .vout(vout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        nrst = 0;
        clk = 0;
        hd_a = 0;
        hd_b = 0;
        start = 0;
        vin = 0;
        #20;
        nrst = 1;
        #10;
    end
    endtask
    task testcase001;

    integer i;
    reg [7:0] send_data;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Decoding 0xA5", test_num);
        reset_dut();
        send_data = 8'hA5;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;


        hd_a = 1;
        @(posedge clk);
        hd_a = 0;
        hd_b = 1;
        @(posedge clk);
        hd_b = 0;


        for (i = 7; i >= 0; i = i - 1) begin
            vin = send_data[i];
            @(posedge clk);
        end


        #1;
        #1;

        check_outputs(8'hA5, 1'b1);
    end
    endtask

    task testcase002;

    integer i;
    reg [7:0] send_data;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Decoding 0x3C", test_num);
        reset_dut();
        send_data = 8'h3C;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        hd_a = 1;
        @(posedge clk);
        hd_a = 0;
        hd_b = 1;
        @(posedge clk);
        hd_b = 0;

        for (i = 7; i >= 0; i = i - 1) begin
            vin = send_data[i];
            @(posedge clk);
        end

        #1;
        #1;

        check_outputs(8'h3C, 1'b1);
    end
    endtask

    task testcase003;

    integer i;
    reg [7:0] send_data;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Decoding 0x00", test_num);
        reset_dut();
        send_data = 8'h00;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        hd_a = 1;
        @(posedge clk);
        hd_a = 0;
        hd_b = 1;
        @(posedge clk);
        hd_b = 0;

        for (i = 7; i >= 0; i = i - 1) begin
            vin = send_data[i];
            @(posedge clk);
        end

        #1;
        #1;

        check_outputs(8'h00, 1'b1);
    end
    endtask

    task testcase004;

    integer i;
    reg [7:0] send_data;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Decoding 0xFF", test_num);
        reset_dut();
        send_data = 8'hFF;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        hd_a = 1;
        @(posedge clk);
        hd_a = 0;
        hd_b = 1;
        @(posedge clk);
        hd_b = 0;

        for (i = 7; i >= 0; i = i - 1) begin
            vin = send_data[i];
            @(posedge clk);
        end

        #1;
        #1;

        check_outputs(8'hFF, 1'b1);
    end
    endtask

    task testcase005;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset during sequence", test_num);
        reset_dut();

        @(posedge clk);
        start = 1;
        @(posedge clk);
        hd_a = 1;
        @(posedge clk);
        nrst = 0;
        #15;
        nrst = 1;

        #10;

        #1;


        check_outputs(8'h00, 1'b0);
    end
    endtask

    task testcase006;

    integer i;
    reg [7:0] send_data;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Decoding 0x55", test_num);
        reset_dut();
        send_data = 8'h55;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        hd_a = 1;
        @(posedge clk);
        hd_a = 0;
        hd_b = 1;
        @(posedge clk);
        hd_b = 0;

        for (i = 7; i >= 0; i = i - 1) begin
            vin = send_data[i];
            @(posedge clk);
        end

        #1;
        #1;

        check_outputs(8'h55, 1'b1);
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
        input [7:0] expected_dout;
        input expected_vout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_vout === (expected_vout ^ vout ^ expected_vout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, vout=%b",
                         dout, vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, vout=%b",
                         expected_dout, expected_vout);
                $display("  Got:      dout=%h, vout=%b",
                         dout, vout);
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
        $dumpvars(0,clk, hd_a, hd_b, nrst, start, vin, dout, vout);
    end

endmodule
