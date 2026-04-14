`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in_vector;
    reg reset;
    wire [31:0] out_vector;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_vector(in_vector),
        .reset(reset),
        .out_vector(out_vector)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 0;
            in_vector = 0;
            @(negedge clk);
            reset = 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            in_vector = 32'h0000_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            in_vector = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: LSB set (Bit 0)", test_num);
            in_vector = 32'h0000_0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: MSB set (Bit 31)", test_num);
            in_vector = 32'h8000_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits A (0xAAAAAAAA)", test_num);
            in_vector = 32'hAAAA_AAAA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits B (0x55555555)", test_num);
            in_vector = 32'h5555_5555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 0x12345678", test_num);
            in_vector = 32'h1234_5678;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h1E6A_2C48);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Symmetric Nibbles (0xF000000F)", test_num);
            in_vector = 32'hF000_000F;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hF000_000F);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 0x0F0F0F0F", test_num);
            in_vector = 32'h0F0F_0F0F;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hF0F0_F0F0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior Check", test_num);
            in_vector = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;

            if (out_vector == 32'hFFFF_FFFF) begin

                reset = 0;
                @(posedge clk);
                #1;
                #1;

                check_outputs(32'h0000_0000);
            end else begin
                $display("FAIL: Initial setup for reset check failed");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_out_vector;
        begin
            if (expected_out_vector === (expected_out_vector ^ out_vector ^ expected_out_vector)) begin
                $display("PASS");
                $display("  Outputs: out_vector=%h",
                         out_vector);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_vector=%h",
                         expected_out_vector);
                $display("  Got:      out_vector=%h",
                         out_vector);
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
        $dumpvars(0,clk, in_vector, reset, out_vector);
    end

endmodule
