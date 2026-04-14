`timescale 1ns/1ps

module ofdm_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] data_in;
    reg rst;
    wire [7:0] I_out;
    wire [7:0] Q_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_modulator dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .I_out(I_out),
        .Q_out(Q_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            data_in = 2'b00;
            @(posedge clk);
            #1 rst = 0;
            $display("DUT Reset completed.");
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Data In = 2'b00");
            reset_dut();
            test_num = test_num + 1;
            @(posedge clk);
            data_in = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h81, 8'h81);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Data In = 2'b01");
            reset_dut();
            test_num = test_num + 1;
            @(posedge clk);
            data_in = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h81, 8'h7F);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Data In = 2'b10");
            reset_dut();
            test_num = test_num + 1;
            @(posedge clk);
            data_in = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h7F, 8'h81);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Data In = 2'b11");
            reset_dut();
            test_num = test_num + 1;
            @(posedge clk);
            data_in = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h7F, 8'h7F);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Reset State Check");
            test_num = test_num + 1;
            @(posedge clk);
            rst = 1;
            data_in = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h00);
            rst = 0;
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Continuous Data Stream (Sequence 00 -> 11)");
            reset_dut();
            test_num = test_num + 1;
            @(posedge clk);
            data_in = 2'b00;
            @(posedge clk);
            data_in = 2'b11;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h7F, 8'h7F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ofdm_modulator Testbench");
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
        input [7:0] expected_I_out;
        input [7:0] expected_Q_out;
        begin
            if (expected_I_out === (expected_I_out ^ I_out ^ expected_I_out) &&
                expected_Q_out === (expected_Q_out ^ Q_out ^ expected_Q_out)) begin
                $display("PASS");
                $display("  Outputs: I_out=%h, Q_out=%h",
                         I_out, Q_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: I_out=%h, Q_out=%h",
                         expected_I_out, expected_Q_out);
                $display("  Got:      I_out=%h, Q_out=%h",
                         I_out, Q_out);
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
        $dumpvars(0,clk, data_in, rst, I_out, Q_out);
    end

endmodule
