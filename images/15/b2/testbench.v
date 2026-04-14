`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg start;
    wire cs;
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
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .cs(cs),
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
        reset = 1;
        start = 0;
        data_in = 8'h00;
        repeat (2) @(posedge clk);
        #1 reset = 0;
        repeat (2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest %03d: Basic Transfer 0xAA", test_num);
        reset_dut();


        data_in = 8'hAA;
        start = 1;
        @(posedge clk);
        #1 start = 0;



        wait(done == 1);
        @(posedge clk);



        #1;




        check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest %03d: Transfer 0x55 (Alternate Pattern)", test_num);
        reset_dut();

        data_in = 8'h55;
        start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(done == 1);
        @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest %03d: Consecutive Back-to-Back Transfers", test_num);
        reset_dut();


        data_in = 8'hF0;
        start = 1;
        @(posedge clk);
        #1 start = 0;
        wait(done == 1);
        @(posedge clk);


        data_in = 8'h0F;
        start = 1;
        @(posedge clk);
        #1 start = 0;
        wait(done == 1);
        @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest %03d: All Zeros Transfer", test_num);
        reset_dut();

        data_in = 8'h00;
        start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(done == 1);
        @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest %03d: All Ones Transfer", test_num);
        reset_dut();

        data_in = 8'hFF;
        start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(done == 1);
        @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest %03d: Mid-Transmission Reset Recovery", test_num);
        reset_dut();


        data_in = 8'hA5;
        start = 1;
        @(posedge clk);
        #1 start = 0;


        repeat (10) @(posedge clk);


        reset = 1;
        @(posedge clk);
        reset = 0;
        repeat (5) @(posedge clk);



        #1;




        check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
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
        input expected_cs;
        input expected_done;
        input expected_mosi;
        input expected_sclk;
        begin
            if (expected_cs === (expected_cs ^ cs ^ expected_cs) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_sclk === (expected_sclk ^ sclk ^ expected_sclk)) begin
                $display("PASS");
                $display("  Outputs: cs=%b, done=%b, mosi=%b, sclk=%b",
                         cs, done, mosi, sclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs=%b, done=%b, mosi=%b, sclk=%b",
                         expected_cs, expected_done, expected_mosi, expected_sclk);
                $display("  Got:      cs=%b, done=%b, mosi=%b, sclk=%b",
                         cs, done, mosi, sclk);
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
        $dumpvars(0,clk, data_in, reset, start, cs, done, mosi, sclk);
    end

endmodule
