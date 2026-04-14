`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg start;
    wire mosi;
    wire sclk;
    wire ss;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master dut (
        .clk(clk),
        .data_in(data_in),
        .start(start),
        .mosi(mosi),
        .sclk(sclk),
        .ss(ss)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            data_in = 8'h00;


            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Running Testcase %03d: Idle State Check", test_num);

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Running Testcase %03d: Transmission Start & MSB High", test_num);
            data_in = 8'h80;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Running Testcase %03d: Transmission Start & MSB Low", test_num);
            data_in = 8'h7F;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Running Testcase %03d: Transmission Persistence", test_num);
            data_in = 8'hAA;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(10) @(posedge clk);



            if (ss == 0) begin
                pass_count = pass_count + 1;
                $display("PASS: SS remained active during transmission");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: SS de-asserted too early");
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Running Testcase %03d: Completion and Idle Return", test_num);
            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(100) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Running Testcase %03d: LSB Check", test_num);
            data_in = 8'h01;
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(18) @(posedge clk);

            if (mosi == 1'b1 && ss == 1'b0) begin
                $display("PASS: LSB '1' detected on MOSI");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: LSB '1' not detected correctly. MOSI=%b, SS=%b", mosi, ss);
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_master Testbench");
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
        input expected_mosi;
        input expected_sclk;
        input expected_ss;
        begin
            if (expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_sclk === (expected_sclk ^ sclk ^ expected_sclk) &&
                expected_ss === (expected_ss ^ ss ^ expected_ss)) begin
                $display("PASS");
                $display("  Outputs: mosi=%b, sclk=%b, ss=%b",
                         mosi, sclk, ss);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mosi=%b, sclk=%b, ss=%b",
                         expected_mosi, expected_sclk, expected_ss);
                $display("  Got:      mosi=%b, sclk=%b, ss=%b",
                         mosi, sclk, ss);
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
        $dumpvars(0,clk, data_in, start, mosi, sclk, ss);
    end

endmodule
