`timescale 1ns/1ps

module dwt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rst;
    wire [3:0] approx;
    wire [3:0] detail;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dwt dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .approx(approx),
        .detail(detail)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case %0d: Constant Input [8, 8, 8, 8]", test_num);

            data_in = 4'd8; @(posedge clk);
            data_in = 4'd8; @(posedge clk);
            data_in = 4'd8; @(posedge clk);
            data_in = 4'd8; @(posedge clk);

            #2;
            #1;

            check_outputs(4'd8, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case %0d: Step Input [10, 2, 12, 4]", test_num);

            data_in = 4'd10; @(posedge clk);
            data_in = 4'd2;  @(posedge clk);
            data_in = 4'd12; @(posedge clk);
            data_in = 4'd4;  @(posedge clk);

            #2;
            #1;

            check_outputs(4'd8, 4'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case %0d: Transition [0, 0, 14, 2]", test_num);

            data_in = 4'd0;  @(posedge clk);
            data_in = 4'd0;  @(posedge clk);
            data_in = 4'd14; @(posedge clk);
            data_in = 4'd2;  @(posedge clk);

            #2;
            #1;

            check_outputs(4'd8, 4'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case %0d: Max Range [15, 15, 15, 1]", test_num);

            data_in = 4'd15; @(posedge clk);
            data_in = 4'd15; @(posedge clk);
            data_in = 4'd15; @(posedge clk);
            data_in = 4'd1;  @(posedge clk);

            #2;
            #1;

            check_outputs(4'd8, 4'd7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dwt Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [3:0] expected_approx;
        input [3:0] expected_detail;
        begin
            if (expected_approx === (expected_approx ^ approx ^ expected_approx) &&
                expected_detail === (expected_detail ^ detail ^ expected_detail)) begin
                $display("PASS");
                $display("  Outputs: approx=%h, detail=%h",
                         approx, detail);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: approx=%h, detail=%h",
                         expected_approx, expected_detail);
                $display("  Got:      approx=%h, detail=%h",
                         approx, detail);
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
        $dumpvars(0,clk, data_in, rst, approx, detail);
    end

endmodule
