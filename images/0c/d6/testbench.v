`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg reset;
    reg valid;
    wire [31:0] data_out;
    wire data_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid(valid),
        .data_out(data_out),
        .data_ready(data_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case 001: Consecutive valid signals (0x12345678)");

            for (i = 0; i < 8; i = i + 1) begin
                data_in = i + 1;
                valid = 1;
                @(posedge clk);
                #1;
            end
            valid = 0;
            #1;

            check_outputs(32'h12345678, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case 002: Intermittent valid signals (Gaps)");

            for (i = 0; i < 8; i = i + 1) begin
                data_in = i;
                valid = 1;
                @(posedge clk);
                #1 valid = 0;
                repeat(2) @(posedge clk);
                #1;
            end
            #1;

            check_outputs(32'h01234567, 1'b1);
        end
        endtask

    task testcase003;

        reg [31:0] pattern;
        begin
            pattern = 32'hDEADBEEF;
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case 003: Specific Hex Pattern (0xDEADBEEF)");

            for (i = 0; i < 8; i = i + 1) begin
                data_in = pattern[(7-i)*4 +: 4];
                valid = 1;
                @(posedge clk);
                #1;
            end
            valid = 0;
            #1;

            check_outputs(32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case 004: All-ones input");

            for (i = 0; i < 8; i = i + 1) begin
                data_in = 4'hF;
                valid = 1;
                @(posedge clk);
                #1;
            end
            valid = 0;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case 005: Reset mid-transaction and recovery");


            for (i = 0; i < 4; i = i + 1) begin
                data_in = 4'hA;
                valid = 1;
                @(posedge clk);
            end

            reset = 1;
            #1 valid = 0;
            @(posedge clk);
            #1 reset = 0;


            for (i = 0; i < 8; i = i + 1) begin
                data_in = i;
                valid = 1;
                @(posedge clk);
                #1;
            end
            valid = 0;
            #1;

            check_outputs(32'h01234567, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer Testbench");
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
        input [31:0] expected_data_out;
        input expected_data_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_ready=%b",
                         data_out, data_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_ready=%b",
                         expected_data_out, expected_data_ready);
                $display("  Got:      data_out=%h, data_ready=%b",
                         data_out, data_ready);
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
        $dumpvars(0,clk, data_in, reset, valid, data_out, data_ready);
    end

endmodule
