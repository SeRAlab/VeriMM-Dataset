`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst;
    wire [8:0] rle_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .rle_out(rle_out),
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
            test_num = 1;
            $display("Testcase %0d: Three consecutive 1s followed by a 0", test_num);
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(9'h007, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Five consecutive 0s followed by a 1", test_num);
            reset_dut();
            data_in = 0; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(9'h00A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Maximum consecutive 1s (8 bits)", test_num);
            reset_dut();
            repeat(8) begin
                data_in = 1; @(posedge clk);
            end

            #1 #1;
 check_outputs(9'h011, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Single 0 bit followed by a 1", test_num);
            reset_dut();
            data_in = 0; @(posedge clk);
            data_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(9'h002, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Maximum consecutive 0s (8 bits)", test_num);
            reset_dut();
            repeat(8) begin
                data_in = 0; @(posedge clk);
            end
            #1 #1;
 check_outputs(9'h010, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset mid-stream verification", test_num);
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            rst = 1;     @(posedge clk);
            rst = 0;
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            #1 #1;
 check_outputs(9'h003, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rle_encoder Testbench");
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
        input [8:0] expected_rle_out;
        input expected_valid;
        begin
            if (expected_rle_out === (expected_rle_out ^ rle_out ^ expected_rle_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: rle_out=%h, valid=%b",
                         rle_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rle_out=%h, valid=%b",
                         expected_rle_out, expected_valid);
                $display("  Got:      rle_out=%h, valid=%b",
                         rle_out, valid);
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
        $dumpvars(0,clk, data_in, rst, rle_out, valid);
    end

endmodule
