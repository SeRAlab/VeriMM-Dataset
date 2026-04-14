`timescale 1ns/1ps

module priority_encoder_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg i_en;
    reg rst_n;
    wire o_valid;
    wire [1:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_4bit dut (
        .clk(clk),
        .data_in(data_in),
        .i_en(i_en),
        .rst_n(rst_n),
        .o_valid(o_valid),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            i_en = 0;
            data_in = 4'b0000;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Bit 3 priority");
            reset_dut();
            data_in = 4'b1000;
            i_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Bit 2 priority");
            reset_dut();
            data_in = 4'b0100;
            i_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Bit 1 priority");
            reset_dut();
            data_in = 4'b0010;
            i_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Bit 0 priority");
            reset_dut();
            data_in = 4'b0001;
            i_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Multiple bits set (1011)");
            reset_dut();
            data_in = 4'b1011;
            i_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Multiple bits set (0110)");
            reset_dut();
            data_in = 4'b0110;
            i_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: i_en is low");
            reset_dut();
            data_in = 4'b1111;
            i_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: No bits set (0000)");
            reset_dut();
            data_in = 4'b0000;
            i_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase009;

        begin
            $display("Running testcase009: All bits set (1111)");
            reset_dut();
            data_in = 4'b1111;
            i_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase010;

        begin
            $display("Running testcase010: Reset state check");

            reset_dut();
            data_in = 4'b1000;
            i_en = 1;
            @(posedge clk);
            #1;

            rst_n = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_4bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_o_valid;
        input [1:0] expected_result;
        begin
            if (expected_o_valid === (expected_o_valid ^ o_valid ^ expected_o_valid) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: o_valid=%b, result=%h",
                         o_valid, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_valid=%b, result=%h",
                         expected_o_valid, expected_result);
                $display("  Got:      o_valid=%b, result=%h",
                         o_valid, result);
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
        $dumpvars(0,clk, data_in, i_en, rst_n, o_valid, result);
    end

endmodule
