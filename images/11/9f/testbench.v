`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cpha;
    reg cpol;
    reg [7:0] data_in;
    reg rst;
    reg start;
    wire cs;
    wire [7:0] data_out;
    wire done;
    wire mosi;
    wire sclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .cpha(cpha),
        .cpol(cpol),
        .data_in(data_in),
        .rst(rst),
        .start(start),
        .cs(cs),
        .data_out(data_out),
        .done(done),
        .mosi(mosi),
        .sclk(sclk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            data_in = 8'h0;
            cpol = 0;
            cpha = 0;
            #20;
            rst = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Mode 0 (CPOL=0, CPHA=0), Data=0xA5", test_num);

            cpol = 0;
            cpha = 0;
            data_in = 8'hA5;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done == 1);
            #10;



            #1;




            check_outputs(1'b1, 8'hA5, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Mode 1 (CPOL=0, CPHA=1), Data=0x5A", test_num);

            cpol = 0;
            cpha = 1;
            data_in = 8'h5A;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            #10;


            #1;



            check_outputs(1'b1, 8'h5A, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Mode 2 (CPOL=1, CPHA=0), Data=0xFF", test_num);

            cpol = 1;
            cpha = 0;
            data_in = 8'hFF;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            #10;


            #1;



            check_outputs(1'b1, 8'hFF, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Mode 3 (CPOL=1, CPHA=1), Data=0x00", test_num);

            cpol = 1;
            cpha = 1;
            data_in = 8'h00;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            #10;


            #1;



            check_outputs(1'b1, 8'h00, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Consecutive Transmissions", test_num);


            cpol = 0; cpha = 0; data_in = 8'hAA;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            #20;


            data_in = 8'hBB;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            #10;


            #1;



            check_outputs(1'b1, 8'hBB, 1'b1, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_controller Testbench");
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
        input expected_cs;
        input [7:0] expected_data_out;
        input expected_done;
        input expected_mosi;
        input expected_sclk;
        begin
            if (expected_cs === (expected_cs ^ cs ^ expected_cs) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_sclk === (expected_sclk ^ sclk ^ expected_sclk)) begin
                $display("PASS");
                $display("  Outputs: cs=%b, data_out=%h, done=%b, mosi=%b, sclk=%b",
                         cs, data_out, done, mosi, sclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs=%b, data_out=%h, done=%b, mosi=%b, sclk=%b",
                         expected_cs, expected_data_out, expected_done, expected_mosi, expected_sclk);
                $display("  Got:      cs=%b, data_out=%h, done=%b, mosi=%b, sclk=%b",
                         cs, data_out, done, mosi, sclk);
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
        $dumpvars(0,clk, cpha, cpol, data_in, rst, start, cs, data_out, done, mosi, sclk);
    end

endmodule
