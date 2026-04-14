`timescale 1ns/1ps

module qam_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] I;
    reg [3:0] Q;
    reg clk;
    wire [7:0] QAM_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qam_transmitter dut (
        .I(I),
        .Q(Q),
        .clk(clk),
        .QAM_signal(QAM_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            I <= 4'b0;
            Q <= 4'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: I=0, Q=0");
            reset_dut();
            I <= 4'h0;
            Q <= 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: I=F, Q=F");
            reset_dut();
            I <= 4'hF;
            Q <= 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: I=A, Q=5");
            reset_dut();
            I <= 4'hA;
            Q <= 4'h5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: I=5, Q=A");
            reset_dut();
            I <= 4'h5;
            Q <= 4'hA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: I=8, Q=8");
            reset_dut();
            I <= 4'h8;
            Q <= 4'h8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h88);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: I=7, Q=B");
            reset_dut();
            I <= 4'h7;
            Q <= 4'hB;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h7B);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: I=1, Q=0");
            reset_dut();
            I <= 4'h1;
            Q <= 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: I=0, Q=1");
            reset_dut();
            I <= 4'h0;
            Q <= 4'h1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qam_transmitter Testbench");
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
        input [7:0] expected_QAM_signal;
        begin
            if (expected_QAM_signal === (expected_QAM_signal ^ QAM_signal ^ expected_QAM_signal)) begin
                $display("PASS");
                $display("  Outputs: QAM_signal=%h",
                         QAM_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: QAM_signal=%h",
                         expected_QAM_signal);
                $display("  Got:      QAM_signal=%h",
                         QAM_signal);
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
        $dumpvars(0,I, Q, clk, QAM_signal);
    end

endmodule
