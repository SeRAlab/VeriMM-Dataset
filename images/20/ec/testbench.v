`timescale 1ns/1ps

module IFFT4_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] in_data;
    wire [63:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    IFFT4 dut (
        .clk(clk),
        .in_data(in_data),
        .out_data(out_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in_data = 64'h0;
            @(posedge clk);
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            in_data = 64'h0;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: DC Impulse (Real)", test_num);
            in_data = 64'h0000_0000_0000_1000;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(64'h0400_0400_0400_0400);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Time Impulse x[0]", test_num);
            in_data = 64'h0400_0400_0400_0400;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(64'h0000_0000_0000_0400);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Frequency Bin 1 (Real)", test_num);
            in_data = 64'h0000_0000_0400_0000;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(64'h00ff_ff00_0001_0100);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Frequency Bin 2 (Real)", test_num);
            in_data = 64'h0000_0400_0000_0000;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(64'hff00_0100_ff00_0100);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Frequency Bin 3 (Real)", test_num);
            in_data = 64'h0400_0000_0000_0000;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(64'h0001_ff00_00ff_0100);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: DC Impulse (Imaginary)", test_num);
            in_data = 64'h0000_0000_0000_0004;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(64'h0001_0001_0001_0001);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Superposition X[0]+X[2]", test_num);
            in_data = 64'h0000_0400_0000_0400;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(64'h0000_0200_0000_0200);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("IFFT4 Testbench");
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
        input [63:0] expected_out_data;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
        $dumpvars(0,clk, in_data, out_data);
    end

endmodule
