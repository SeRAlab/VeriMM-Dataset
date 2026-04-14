`timescale 1ns/1ps

module linear_voltage_regulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] ctrl;
    reg rst;
    reg [7:0] vin;
    wire [7:0] vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_voltage_regulator dut (
        .clk(clk),
        .ctrl(ctrl),
        .rst(rst),
        .vin(vin),
        .vout(vout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        vin = 0;
        ctrl = 0;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Test Case 001: Reset State - Checking if vout is 0");
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Test Case 002: Ctrl=00, Vin=255 - Expect vout=0");
        vin = 8'hFF;
        ctrl = 2'b00;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Test Case 003: Ctrl=01 (Target 64), Vin=200 - Expect vout=64");
        vin = 8'd200;
        ctrl = 2'b01;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(8'd64);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Test Case 004: Ctrl=10 (Target 128), Vin=200 - Expect vout=128");
        vin = 8'd200;
        ctrl = 2'b10;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(8'd128);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Test Case 005: Ctrl=11 (Target 192), Vin=255 - Expect vout=192");
        vin = 8'd255;
        ctrl = 2'b11;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(8'd192);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        $display("Test Case 006: Clamping - Ctrl=11 (Target 192), Vin=100 - Expect vout=100");
        vin = 8'd100;
        ctrl = 2'b11;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        $display("Test Case 007: Clamping - Ctrl=01 (Target 64), Vin=30 - Expect vout=30");
        vin = 8'd30;
        ctrl = 2'b01;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        $display("Test Case 008: Dynamic Input Change - Vin dropping below Target");
        vin = 8'd200;
        ctrl = 2'b10;
        repeat(2) @(posedge clk);
        vin = 8'd50;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(8'd50);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linear_voltage_regulator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_vout;
        begin
            if (expected_vout === (expected_vout ^ vout ^ expected_vout)) begin
                $display("PASS");
                $display("  Outputs: vout=%h",
                         vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vout=%h",
                         expected_vout);
                $display("  Got:      vout=%h",
                         vout);
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
        $dumpvars(0,clk, ctrl, rst, vin, vout);
    end

endmodule
