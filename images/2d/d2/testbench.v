`timescale 1ns/1ps

module rle_compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] pixel_in;
    reg rst;
    wire [3:0] count_out;
    wire [7:0] pixel_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_compressor dut (
        .clk(clk),
        .pixel_in(pixel_in),
        .rst(rst),
        .count_out(count_out),
        .pixel_out(pixel_out),
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
            pixel_in = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Simple run of 5", test_num);
            reset_dut();


            repeat(5) begin
                pixel_in = 8'hAA;
                @(posedge clk);
            end


            pixel_in = 8'hBB;
            @(posedge clk);

            #1 #1;
 check_outputs(4'd5, 8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Single pixel run", test_num);
            reset_dut();

            pixel_in = 8'h11;
            @(posedge clk);


            pixel_in = 8'h22;
            @(posedge clk);

            #1 #1;
 check_outputs(4'd1, 8'h11, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Maximum count (15)", test_num);
            reset_dut();

            repeat(15) begin
                pixel_in = 8'hFF;
                @(posedge clk);
            end


            pixel_in = 8'h00;
            @(posedge clk);

            #1 #1;
 check_outputs(4'd15, 8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Sequential runs", test_num);
            reset_dut();


            repeat(3) begin
                pixel_in = 8'h55;
                @(posedge clk);
            end


            repeat(2) begin
                pixel_in = 8'h66;
                @(posedge clk);
            end


            pixel_in = 8'h77;
            @(posedge clk);


            #1 #1;
 check_outputs(4'd2, 8'h66, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Reset behavior", test_num);
            reset_dut();

            repeat(4) begin
                pixel_in = 8'hCC;
                @(posedge clk);
            end


            rst = 1;
            @(posedge clk);
            #1 rst = 0;


            #1;



            check_outputs(4'd0, 8'h00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rle_compressor Testbench");
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
        input [3:0] expected_count_out;
        input [7:0] expected_pixel_out;
        input expected_valid;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_pixel_out === (expected_pixel_out ^ pixel_out ^ expected_pixel_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, pixel_out=%h, valid=%b",
                         count_out, pixel_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, pixel_out=%h, valid=%b",
                         expected_count_out, expected_pixel_out, expected_valid);
                $display("  Got:      count_out=%h, pixel_out=%h, valid=%b",
                         count_out, pixel_out, valid);
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
        $dumpvars(0,clk, pixel_in, rst, count_out, pixel_out, valid);
    end

endmodule
