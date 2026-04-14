`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire [7:0] frame_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .frame_count(frame_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        data_in = 8'h00;
        @(posedge clk);
        #2;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Reset Check");
        reset_dut();

        #1;


        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Single data reception");
        reset_dut();
        data_in = 8'hAA;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = 3;
        $display("Testcase 003: Multiple data receptions (10 cycles)");
        reset_dut();
        for (i = 0; i < 10; i = i + 1) begin
            data_in = i + 1;
            @(posedge clk);
        end
        #1;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = 4;
        $display("Testcase 004: Counter overflow/wrap-around");
        reset_dut();

        for (i = 0; i < 256; i = i + 1) begin
            data_in = 8'hFF;
            @(posedge clk);
        end
        #1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = 5;
        $display("Testcase 005: Reset mid-operation");
        reset_dut();

        for (i = 0; i < 5; i = i + 1) begin
            data_in = 8'h11;
            @(posedge clk);
        end

        rst = 1;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = 6;
        $display("Testcase 006: Varying data values check");
        reset_dut();
        data_in = 8'hDE; @(posedge clk);
        data_in = 8'hAD; @(posedge clk);
        data_in = 8'hBE; @(posedge clk);
        data_in = 8'hEF; @(posedge clk);
        #1;
        #1;

        check_outputs(8'd4);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input [7:0] expected_frame_count;
        begin
            if (expected_frame_count === (expected_frame_count ^ frame_count ^ expected_frame_count)) begin
                $display("PASS");
                $display("  Outputs: frame_count=%h",
                         frame_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_count=%h",
                         expected_frame_count);
                $display("  Got:      frame_count=%h",
                         frame_count);
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
        $dumpvars(0,clk, data_in, rst, frame_count);
    end

endmodule
