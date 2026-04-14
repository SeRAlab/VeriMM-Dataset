`timescale 1ns/1ps

module i2c_controller_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] address;
    reg clk;
    reg [7:0] data;
    reg reset;
    reg start;
    wire busy;
    wire scl;
    wire sda;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    i2c_controller dut (
        .address(address),
        .clk(clk),
        .data(data),
        .reset(reset),
        .start(start),
        .busy(busy),
        .scl(scl),
        .sda(sda)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        address = 0;
        data = 0;
        start = 0;
        repeat(5) @(posedge clk);
        reset = 0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %03d: Standard Transfer (Addr: 0x55, Data: 0xAA)", test_num);
        reset_dut();

        address = 7'h55;
        data = 8'hAA;
        start = 1;
        @(posedge clk);
        #1; start = 0;


        wait(busy === 1'b1);

        wait(busy === 1'b0);

        repeat(2) @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %03d: Minimum Values (Addr: 0x00, Data: 0x00)", test_num);
        reset_dut();

        address = 7'h00;
        data = 8'h00;
        start = 1;
        @(posedge clk);
        #1; start = 0;

        wait(busy === 1'b1);
        wait(busy === 1'b0);

        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %03d: Maximum Values (Addr: 0x7F, Data: 0xFF)", test_num);
        reset_dut();

        address = 7'h7F;
        data = 8'hFF;
        start = 1;
        @(posedge clk);
        #1; start = 0;

        wait(busy === 1'b1);
        wait(busy === 1'b0);

        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %03d: Alternating Patterns (Addr: 0x2A, Data: 0x33)", test_num);
        reset_dut();

        address = 7'h2A;
        data = 8'h33;
        start = 1;
        @(posedge clk);
        #1; start = 0;

        wait(busy === 1'b1);
        wait(busy === 1'b0);

        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %03d: Reset during transaction", test_num);
        reset_dut();

        address = 7'h3C;
        data = 8'hC3;
        start = 1;
        @(posedge clk);
        #1; start = 0;


        wait(busy === 1'b1);
        repeat(10) @(posedge clk);


        reset = 1;
        repeat(2) @(posedge clk);
        reset = 0;
        repeat(2) @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b1, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("i2c_controller Testbench");
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
        input expected_busy;
        input expected_scl;
        input expected_sda;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_scl === (expected_scl ^ scl ^ expected_scl) &&
                expected_sda === (expected_sda ^ sda ^ expected_sda)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, scl=%b, sda=%b",
                         busy, scl, sda);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, scl=%b, sda=%b",
                         expected_busy, expected_scl, expected_sda);
                $display("  Got:      busy=%b, scl=%b, sda=%b",
                         busy, scl, sda);
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
        $dumpvars(0,address, clk, data, reset, start, busy, scl, sda);
    end

endmodule
