`timescale 1ns/1ps

module crc4_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    wire [3:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc4 dut (
        .clk(clk),
        .data_in(data_in),
        .crc_out(crc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            data_in = 4'h0;
            @(posedge clk);
            #1;
            $write("Test Case %0d: Input=4'h0 -> ", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            data_in = 4'h8;
            @(posedge clk);
            #1;
            $write("Test Case %0d: Input=4'h8 -> ", test_num);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            data_in = 4'hF;
            @(posedge clk);
            #1;
            $write("Test Case %0d: Input=4'hF -> ", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            data_in = 4'h1;
            @(posedge clk);
            #1;
            $write("Test Case %0d: Input=4'h1 -> ", test_num);
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            data_in = 4'hA;
            @(posedge clk);
            #1;
            $write("Test Case %0d: Input=4'hA -> ", test_num);
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            data_in = 4'h5;
            @(posedge clk);
            #1;
            $write("Test Case %0d: Input=4'h5 -> ", test_num);
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            data_in = 4'h2;
            @(posedge clk);
            #1;
            $write("Test Case %0d: Input=4'h2 -> ", test_num);
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            data_in = 4'h4;
            @(posedge clk);
            #1;
            $write("Test Case %0d: Input=4'h4 -> ", test_num);
            #1;

            check_outputs(4'hE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc4 Testbench");
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
        input [3:0] expected_crc_out;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h",
                         crc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h",
                         expected_crc_out);
                $display("  Got:      crc_out=%h",
                         crc_out);
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
        $dumpvars(0,clk, data_in, crc_out);
    end

endmodule
