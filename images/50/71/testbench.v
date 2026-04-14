`timescale 1ns/1ps

module binary_to_gray_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] binary_in;
    reg clk;
    reg rst_n;
    wire [7:0] gray_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_gray dut (
        .binary_in(binary_in),
        .clk(clk),
        .rst_n(rst_n),
        .gray_out(gray_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            binary_in = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing Zero Input", test_num);
            reset_dut();
            binary_in = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Testing Binary 1", test_num);
            reset_dut();
            binary_in = 8'h01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Testing Binary 3 (0011 -> 0010)", test_num);
            reset_dut();
            binary_in = 8'h03;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Testing Binary 4 (0100 -> 0110)", test_num);
            reset_dut();
            binary_in = 8'h04;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Testing Binary 255 (All 1s)", test_num);
            reset_dut();
            binary_in = 8'hFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Testing Binary 0xAA (10101010)", test_num);
            reset_dut();
            binary_in = 8'hAA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Testing Binary 0x55 (01010101)", test_num);
            reset_dut();
            binary_in = 8'h55;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h7F);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Testing Binary 127 (0111_1111)", test_num);
            reset_dut();
            binary_in = 8'h7F;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h40);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Testing Binary 128 (1000_0000)", test_num);
            reset_dut();
            binary_in = 8'h80;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hC0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_to_gray Testbench");
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
        input [7:0] expected_gray_out;
        begin
            if (expected_gray_out === (expected_gray_out ^ gray_out ^ expected_gray_out)) begin
                $display("PASS");
                $display("  Outputs: gray_out=%h",
                         gray_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray_out=%h",
                         expected_gray_out);
                $display("  Got:      gray_out=%h",
                         gray_out);
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
        $dumpvars(0,binary_in, clk, rst_n, gray_out);
    end

endmodule
