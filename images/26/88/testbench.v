`timescale 1ns/1ps

module checksum_generator_checker_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] checksum_in;
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire [7:0] checksum_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_generator_checker dut (
        .checksum_in(checksum_in),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .checksum_out(checksum_out),
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
            data_in = 8'h00;
            checksum_in = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros (Valid)", test_num);
            reset_dut();
            data_in = 8'b0000_0000;
            checksum_in = 8'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones (Valid)", test_num);
            reset_dut();
            data_in = 8'b1111_1111;
            checksum_in = 8'd8;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd8, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (Valid)", test_num);
            reset_dut();
            data_in = 8'b1010_1010;
            checksum_in = 8'd4;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd4, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mismatched Checksum (Invalid)", test_num);
            reset_dut();
            data_in = 8'b1111_0000;
            checksum_in = 8'd5;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd4, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Bit (Valid)", test_num);
            reset_dut();
            data_in = 8'b0000_0001;
            checksum_in = 8'd1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Checksum In is 0 but Data is FF (Invalid)", test_num);
            reset_dut();
            data_in = 8'hFF;
            checksum_in = 8'h00;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd8, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random pattern (Valid)", test_num);
            reset_dut();
            data_in = 8'b0110_1101;
            checksum_in = 8'd5;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd5, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum_generator_checker Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_checksum_out;
        input expected_valid;
        begin
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h, valid=%b",
                         checksum_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h, valid=%b",
                         expected_checksum_out, expected_valid);
                $display("  Got:      checksum_out=%h, valid=%b",
                         checksum_out, valid);
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
        $dumpvars(0,checksum_in, clk, data_in, rst, checksum_out, valid);
    end

endmodule
