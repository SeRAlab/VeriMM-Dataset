`timescale 1ns/1ps

module QAM_Modulator_tb;

    // Testbench signals (sequential circuit)
    reg I;
    reg Q;
    reg clk;
    reg rst;
    wire [1:0] QAM_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    QAM_Modulator dut (
        .I(I),
        .Q(Q),
        .clk(clk),
        .rst(rst),
        .QAM_out(QAM_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            I = 0;
            Q = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input I=0, Q=0", test_num);
            reset_dut();
            I = 0;
            Q = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input I=0, Q=1", test_num);
            reset_dut();
            I = 0;
            Q = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input I=1, Q=0", test_num);
            reset_dut();
            I = 1;
            Q = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input I=1, Q=1", test_num);
            reset_dut();
            I = 1;
            Q = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Behavior Check", test_num);
            reset_dut();
            I = 1;
            Q = 1;
            @(posedge clk);
            #1;

            rst = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00);
            rst = 0;
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
        input [1:0] expected_QAM_out;
        begin
            if (expected_QAM_out === (expected_QAM_out ^ QAM_out ^ expected_QAM_out)) begin
                $display("PASS");
                $display("  Outputs: QAM_out=%h",
                         QAM_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: QAM_out=%h",
                         expected_QAM_out);
                $display("  Got:      QAM_out=%h",
                         QAM_out);
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
        $dumpvars(0,I, Q, clk, rst, QAM_out);
    end

endmodule
