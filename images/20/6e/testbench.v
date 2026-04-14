`timescale 1ns/1ps

module ReedSolomonEncoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg valid;
    wire [7:0] encoded_out;
    wire encoded_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ReedSolomonEncoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid(valid),
        .encoded_out(encoded_out),
        .encoded_valid(encoded_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid = 0;
            data_in = 8'h00;
            repeat(5) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros Data Block", test_num);
            reset_dut();


            for (i = 0; i < K_DATA; i = i + 1) begin
                data_in = 8'h00;
                valid = 1;
                @(posedge clk);
            end
            valid = 0;



            repeat(N_TOTAL - 1) @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b1);


            @(posedge clk);
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Incremental Data (0x01 to 0x08)", test_num);
            reset_dut();

            for (i = 0; i < K_DATA; i = i + 1) begin
                data_in = i + 1;
                valid = 1;
                @(posedge clk);
            end
            valid = 0;


            repeat(N_TOTAL - 1) @(posedge clk);




            if (encoded_valid === 1'b1) begin
                $display("  Info: Received parity byte %h at end of sequence", encoded_out);
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL: Valid signal dropped prematurely");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All 0xFF Data Block", test_num);
            reset_dut();

            for (i = 0; i < K_DATA; i = i + 1) begin
                data_in = 8'hFF;
                valid = 1;
                @(posedge clk);
            end
            valid = 0;


            repeat(N_TOTAL) @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ReedSolomonEncoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        input [7:0] expected_encoded_out;
        input expected_encoded_valid;
        begin
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out) &&
                expected_encoded_valid === (expected_encoded_valid ^ encoded_valid ^ expected_encoded_valid)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h, encoded_valid=%b",
                         encoded_out, encoded_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h, encoded_valid=%b",
                         expected_encoded_out, expected_encoded_valid);
                $display("  Got:      encoded_out=%h, encoded_valid=%b",
                         encoded_out, encoded_valid);
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
        $dumpvars(0,clk, data_in, rst, valid, encoded_out, encoded_valid);
    end

endmodule
