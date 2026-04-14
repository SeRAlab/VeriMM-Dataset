`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (sequential circuit)
    reg calc_en;
    reg clk;
    reg [15:0] data_in;
    reg rst;
    wire [15:0] checksum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .calc_en(calc_en),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .checksum_out(checksum_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            calc_en = 0;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Addition", test_num);
            reset_dut();

            @(posedge clk);
            calc_en = 1;
            data_in = 16'h1111;
            @(posedge clk);
            data_in = 16'h2222;
            @(posedge clk);
            calc_en = 0;
            data_in = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'hCCCC);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Carry Wrap", test_num);
            reset_dut();

            @(posedge clk);
            calc_en = 1;
            data_in = 16'hFFFF;
            @(posedge clk);
            data_in = 16'h0001;
            @(posedge clk);
            calc_en = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Values", test_num);
            reset_dut();

            @(posedge clk);
            calc_en = 1;
            data_in = 16'hFFFF;
            @(posedge clk);
            data_in = 16'hFFFF;
            @(posedge clk);
            calc_en = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Inputs", test_num);
            reset_dut();

            @(posedge clk);
            calc_en = 1;
            data_in = 16'h0000;
            @(posedge clk);
            data_in = 16'h0000;
            @(posedge clk);
            calc_en = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Words Sequence", test_num);
            reset_dut();

            @(posedge clk);
            calc_en = 1;
            data_in = 16'h4500;
            @(posedge clk);
            data_in = 16'h003C;
            @(posedge clk);
            data_in = 16'h1C46;
            @(posedge clk);
            calc_en = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h9E7D);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Accumulative Carry Wrap", test_num);
            reset_dut();

            @(posedge clk);
            calc_en = 1;
            data_in = 16'h8000;
            @(posedge clk);
            data_in = 16'h8000;
            @(posedge clk);
            data_in = 16'h8000;
            @(posedge clk);
            data_in = 16'h8000;
            @(posedge clk);
            calc_en = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'hFFFD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ip_checksum Testbench");
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
        input [15:0] expected_checksum_out;
        begin
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h",
                         checksum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h",
                         expected_checksum_out);
                $display("  Got:      checksum_out=%h",
                         checksum_out);
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
        $dumpvars(0,calc_en, clk, data_in, rst, checksum_out);
    end

endmodule
