`timescale 1ns/1ps

module QAM_Encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] data_in;
    wire [3:0] I_out;
    wire [3:0] Q_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    QAM_Encoder dut (
        .clk(clk),
        .data_in(data_in),
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
            data_in <= 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Data In = 00");
            reset_dut();
            data_in <= 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h1, 4'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Data In = 01");
            reset_dut();
            data_in <= 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h1, 4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Data In = 10");
            reset_dut();
            data_in <= 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF, 4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Data In = 11");
            reset_dut();
            data_in <= 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Sequential Transition 00 -> 11");
            reset_dut();
            data_in <= 2'b00;
            @(posedge clk);
            #1;
            data_in <= 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF, 4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("QAM_Encoder Testbench");
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
        input [3:0] expected_I_out;
        input [3:0] expected_Q_out;
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
        $dumpvars(0,clk, data_in, I_out, Q_out);
    end

endmodule
