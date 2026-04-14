`timescale 1ns/1ps

module ofdm_mapper_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rst;
    wire [3:0] subcarrier_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_mapper dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .subcarrier_out(subcarrier_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 4'b0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Input 4'h0", test_num);
            reset_dut();
            data_in = 4'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Input 4'hF (Boundary)", test_num);
            reset_dut();
            data_in = 4'hF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Input 4'h5 (Pattern 0101)", test_num);
            reset_dut();
            data_in = 4'h5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Input 4'hA (Pattern 1010)", test_num);
            reset_dut();
            data_in = 4'hA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Input 4'h7", test_num);
            reset_dut();
            data_in = 4'h7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Input 4'hC", test_num);
            reset_dut();
            data_in = 4'hC;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ofdm_mapper Testbench");
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
        input [3:0] expected_subcarrier_out;
        begin
            if (expected_subcarrier_out === (expected_subcarrier_out ^ subcarrier_out ^ expected_subcarrier_out)) begin
                $display("PASS");
                $display("  Outputs: subcarrier_out=%h",
                         subcarrier_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: subcarrier_out=%h",
                         expected_subcarrier_out);
                $display("  Got:      subcarrier_out=%h",
                         subcarrier_out);
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
        $dumpvars(0,clk, data_in, rst, subcarrier_out);
    end

endmodule
