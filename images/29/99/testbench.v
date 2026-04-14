`timescale 1ns/1ps

module RLE_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst;
    wire [3:0] count;
    wire data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RLE dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .count(count),
        .data_out(data_out),
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
        data_in = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Run of four 1s followed by a 0", test_num);


        repeat(4) begin
            data_in = 1;
            @(posedge clk);
        end


        data_in = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'd4, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Run of seven 0s followed by a 1", test_num);


        repeat(7) begin
            data_in = 0;
            @(posedge clk);
        end


        data_in = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'd7, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Single 1 followed by a 0", test_num);

        data_in = 1;
        @(posedge clk);

        data_in = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'd1, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Run of fifteen 0s followed by a 1", test_num);

        repeat(15) begin
            data_in = 0;
            @(posedge clk);
        end

        data_in = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'd15, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Multiple consecutive runs (3 ones, then 2 zeros)", test_num);


        repeat(3) begin
            data_in = 1;
            @(posedge clk);
        end


        data_in = 0;
        @(posedge clk);


        data_in = 0;
        @(posedge clk);


        data_in = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'd2, 1'b0, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RLE Testbench");
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
        input [3:0] expected_count;
        input expected_data_out;
        input expected_valid;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: count=%h, data_out=%b, valid=%b",
                         count, data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, data_out=%b, valid=%b",
                         expected_count, expected_data_out, expected_valid);
                $display("  Got:      count=%h, data_out=%b, valid=%b",
                         count, data_out, valid);
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
        $dumpvars(0,clk, data_in, rst, count, data_out, valid);
    end

endmodule
