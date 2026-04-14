`timescale 1ns/1ps

module QAM_Modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg reset;
    wire [15:0] I_out;
    wire [15:0] Q_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    QAM_Modulator dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
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
            reset = 1;
            data_in = 4'b0000;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data_in = 4'b0000;
            @(posedge clk);
            #2;
            $display("Test %0d: Data 0000", test_num);
            #1;

            check_outputs(16'h0001, 16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data_in = 4'b0001;
            @(posedge clk);
            #2;
            $display("Test %0d: Data 0001", test_num);
            #1;

            check_outputs(16'h0001, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data_in = 4'b0010;
            @(posedge clk);
            #2;
            $display("Test %0d: Data 0010", test_num);
            #1;

            check_outputs(16'hFFFF, 16'h0001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data_in = 4'b0011;
            @(posedge clk);
            #2;
            $display("Test %0d: Data 0011", test_num);
            #1;

            check_outputs(16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data_in = 4'b0100;
            @(posedge clk);
            #2;
            $display("Test %0d: Data 0100", test_num);
            #1;

            check_outputs(16'h0001, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data_in = 4'b0101;
            @(posedge clk);
            #2;
            $display("Test %0d: Data 0101", test_num);
            #1;

            check_outputs(16'h0000, 16'h0001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data_in = 4'b0110;
            @(posedge clk);
            #2;
            $display("Test %0d: Data 0110", test_num);
            #1;

            check_outputs(16'h0000, 16'hFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            data_in = 4'b0111;
            @(posedge clk);
            #2;
            $display("Test %0d: Data 0111", test_num);
            #1;

            check_outputs(16'hFFFF, 16'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            data_in = 4'b1000;
            @(posedge clk);
            #2;
            $display("Test %0d: Data 1000", test_num);
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            data_in = 4'b1001;
            @(posedge clk);
            #2;
            $display("Test %0d: Data 1001", test_num);
            #1;

            check_outputs(16'h0001, 16'h0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("QAM_Modulator Testbench");
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
        input [15:0] expected_I_out;
        input [15:0] expected_Q_out;
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
        $dumpvars(0,clk, data_in, reset, I_out, Q_out);
    end

endmodule
