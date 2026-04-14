`timescale 1ns/1ps

module i2c_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable;
    wire scl;
    wire sda;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    i2c_master dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
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
        enable = 0;
        data_in = 8'h00;

        repeat(5) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Basic Transmission (Data = 8'hA5)", test_num);
        reset_dut();


        data_in = 8'hA5;
        enable = 1;




        repeat(1000) @(posedge clk);

        enable = 0;
        repeat(20) @(posedge clk);


        #1;



        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Send All Zeros (Data = 8'h00)", test_num);
        reset_dut();

        data_in = 8'h00;
        enable = 1;

        repeat(1000) @(posedge clk);

        enable = 0;
        repeat(20) @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Send All Ones (Data = 8'hFF)", test_num);
        reset_dut();

        data_in = 8'hFF;
        enable = 1;

        repeat(1000) @(posedge clk);

        enable = 0;
        repeat(20) @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Multiple Consecutive Bytes (0x12 then 0x34)", test_num);
        reset_dut();


        data_in = 8'h12;
        enable = 1;
        repeat(800) @(posedge clk);


        enable = 0;
        repeat(50) @(posedge clk);
        data_in = 8'h34;
        enable = 1;
        repeat(1000) @(posedge clk);

        enable = 0;
        repeat(20) @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Idle State Persistence (Enable Low)", test_num);
        reset_dut();

        data_in = 8'hAA;
        enable = 0;

        repeat(100) @(posedge clk);


        #1;



        check_outputs(1'b1, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("i2c_master Testbench");
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
        input expected_scl;
        input expected_sda;
        begin
            if (expected_scl === (expected_scl ^ scl ^ expected_scl) &&
                expected_sda === (expected_sda ^ sda ^ expected_sda)) begin
                $display("PASS");
                $display("  Outputs: scl=%b, sda=%b",
                         scl, sda);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: scl=%b, sda=%b",
                         expected_scl, expected_sda);
                $display("  Got:      scl=%b, sda=%b",
                         scl, sda);
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
        $dumpvars(0,clk, data_in, enable, scl, sda);
    end

endmodule
