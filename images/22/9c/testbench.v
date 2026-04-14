`timescale 1ns/1ps

module fractional_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] frac;
    reg [15:0] input_freq;
    wire [31:0] ctrl_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_pll dut (
        .clk(clk),
        .frac(frac),
        .input_freq(input_freq),
        .ctrl_signal(ctrl_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            input_freq <= 16'h0;
            frac <= 16'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            input_freq <= 16'd0;
            frac <= 16'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            input_freq <= 16'd500;
            frac <= 16'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd500);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            input_freq <= 16'd100;
            frac <= 16'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd2500);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            input_freq <= 16'd1000;
            frac <= 16'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd100000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            input_freq <= 16'hFFFF;
            frac <= 16'hFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFE0001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            input_freq <= 16'd123;
            frac <= 16'd456;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd56088);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            input_freq <= 16'd5000;
            frac <= 16'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fractional_n_pll Testbench");
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
        input [31:0] expected_ctrl_signal;
        begin
            if (expected_ctrl_signal === (expected_ctrl_signal ^ ctrl_signal ^ expected_ctrl_signal)) begin
                $display("PASS");
                $display("  Outputs: ctrl_signal=%h",
                         ctrl_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ctrl_signal=%h",
                         expected_ctrl_signal);
                $display("  Got:      ctrl_signal=%h",
                         ctrl_signal);
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
        $dumpvars(0,clk, frac, input_freq, ctrl_signal);
    end

endmodule
