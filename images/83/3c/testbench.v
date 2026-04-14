`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    wire out_and;
    wire out_or;
    wire out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting pipeline...");
            in = 4'b0000;
            repeat (4) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: All inputs 0", test_num);


            in = 4'b0000; @(posedge clk);

            in = 4'b0000; @(posedge clk);

            in = 4'b0000; @(posedge clk);

            #1;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: All selected bits 1", test_num);


            in = 4'b0100; @(posedge clk);

            in = 4'b0010; @(posedge clk);

            in = 4'b0001; @(posedge clk);

            #1;
            #1;

            check_outputs(1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Only Reg1[0] is 1", test_num);

            in = 4'b0000; @(posedge clk);
            in = 4'b0000; @(posedge clk);
            in = 4'b0001; @(posedge clk);

            #1;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Only Reg2[1] is 1", test_num);

            in = 4'b0000; @(posedge clk);
            in = 4'b0010; @(posedge clk);
            in = 4'b0000; @(posedge clk);

            #1;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Only Reg3[2] is 1", test_num);

            in = 4'b0100; @(posedge clk);
            in = 4'b0000; @(posedge clk);
            in = 4'b0000; @(posedge clk);

            #1;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Two bits 1 (Reg1[0], Reg2[1])", test_num);

            in = 4'b0000; @(posedge clk);
            in = 4'b0010; @(posedge clk);
            in = 4'b0001; @(posedge clk);

            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Irrelevant bits set high", test_num);


            in = 4'b1011; @(posedge clk);

            in = 4'b1101; @(posedge clk);

            in = 4'b1110; @(posedge clk);

            #1;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Complex stream check", test_num);


            in = 4'b0100; @(posedge clk);
            in = 4'b1101; @(posedge clk);
            in = 4'b1011; @(posedge clk);

            #1;
            #1;

            check_outputs(0, 1, 0);
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
        input expected_out_and;
        input expected_out_or;
        input expected_out_xor;
        begin
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_and=%b, out_or=%b, out_xor=%b",
                         out_and, out_or, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%b, out_or=%b, out_xor=%b",
                         expected_out_and, expected_out_or, expected_out_xor);
                $display("  Got:      out_and=%b, out_or=%b, out_xor=%b",
                         out_and, out_or, out_xor);
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
        $dumpvars(0,clk, in, out_and, out_or, out_xor);
    end

endmodule
