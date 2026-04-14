`timescale 1ns/1ps

module checksum_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data;
    reg reset;
    wire [4:0] checksum_out;
    wire checksum_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .checksum_out(checksum_out),
        .checksum_valid(checksum_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            data = 5'b0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data = 00000", test_num);
            reset_dut();
            data = 5'b00000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data = 11111", test_num);
            reset_dut();
            data = 5'b11111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data = 10101", test_num);
            reset_dut();
            data = 5'b10101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data = 01100", test_num);
            reset_dut();
            data = 5'b01100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data = 10000", test_num);
            reset_dut();
            data = 5'b10000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Priority Check", test_num);
            @(negedge clk);
            reset = 1;
            data = 5'b11111;
            @(posedge clk);
            #1;



            if (checksum_valid == 1'b0) begin
                $display("PASS: checksum_valid stayed low during reset");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: checksum_valid high during reset");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Consecutive Updates", test_num);
            reset_dut();

            data = 5'b00001;
            @(posedge clk);
            #1;

            data = 5'b00011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum Testbench");
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
        input [4:0] expected_checksum_out;
        input expected_checksum_valid;
        begin
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out) &&
                expected_checksum_valid === (expected_checksum_valid ^ checksum_valid ^ expected_checksum_valid)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h, checksum_valid=%b",
                         checksum_out, checksum_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h, checksum_valid=%b",
                         expected_checksum_out, expected_checksum_valid);
                $display("  Got:      checksum_out=%h, checksum_valid=%b",
                         checksum_out, checksum_valid);
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
        $dumpvars(0,clk, data, reset, checksum_out, checksum_valid);
    end

endmodule
