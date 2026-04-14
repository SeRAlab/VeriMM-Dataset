`timescale 1ns/1ps

module encoder_pipe_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg i_en;
    reg [31:0] in_data;
    reg rst_n;
    wire o_en;
    wire [4:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encoder_pipe_32bit dut (
        .clk(clk),
        .i_en(i_en),
        .in_data(in_data),
        .rst_n(rst_n),
        .o_en(o_en),
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
            in_data = 32'h0;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Testing MSB (Bit 31)");
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            i_en <= 1;
            in_data <= 32'h8000_0000;
            @(posedge clk);
            i_en <= 0;
            in_data <= 0;


            while (!o_en) @(posedge clk);
            #1;

            check_outputs(1'b1, 5'd31);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Testing LSB (Bit 0)");
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            i_en <= 1;
            in_data <= 32'h0000_0001;
            @(posedge clk);
            i_en <= 0;
            in_data <= 0;

            while (!o_en) @(posedge clk);
            #1;

            check_outputs(1'b1, 5'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Testing Middle Bit (Bit 15)");
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            i_en <= 1;
            in_data <= 32'h0000_8000;
            @(posedge clk);
            i_en <= 0;
            in_data <= 0;

            while (!o_en) @(posedge clk);
            #1;

            check_outputs(1'b1, 5'd15);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Multiple bits (31 and 0), expecting 31");
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            i_en <= 1;
            in_data <= 32'h8000_0001;
            @(posedge clk);
            i_en <= 0;
            in_data <= 0;

            while (!o_en) @(posedge clk);
            #1;

            check_outputs(1'b1, 5'd31);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Multiple bits (20, 19, 10), expecting 20");
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            i_en <= 1;
            in_data <= (32'h1 << 20) | (32'h1 << 19) | (32'h1 << 10);
            @(posedge clk);
            i_en <= 0;
            in_data <= 0;

            while (!o_en) @(posedge clk);
            #1;

            check_outputs(1'b1, 5'd20);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: All bits set, expecting 31");
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            i_en <= 1;
            in_data <= 32'hFFFF_FFFF;
            @(posedge clk);
            i_en <= 0;
            in_data <= 0;

            while (!o_en) @(posedge clk);
            #1;

            check_outputs(1'b1, 5'd31);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Testing Bit 7");
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            i_en <= 1;
            in_data <= 32'h0000_0080;
            @(posedge clk);
            i_en <= 0;
            in_data <= 0;

            while (!o_en) @(posedge clk);
            #1;

            check_outputs(1'b1, 5'd7);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: No bits set");
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            i_en <= 1;
            in_data <= 32'h0000_0000;
            @(posedge clk);
            i_en <= 0;
            in_data <= 0;

            while (!o_en) @(posedge clk);


            #1;



            check_outputs(1'b1, 5'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("encoder_pipe_32bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_o_en;
        input [4:0] expected_result;
        begin
            if (expected_o_en === (expected_o_en ^ o_en ^ expected_o_en) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: o_en=%b, result=%h",
                         o_en, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_en=%b, result=%h",
                         expected_o_en, expected_result);
                $display("  Got:      o_en=%b, result=%h",
                         o_en, result);
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
        $dumpvars(0,clk, i_en, in_data, rst_n, o_en, result);
    end

endmodule
