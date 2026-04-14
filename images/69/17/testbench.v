`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] addr;
    reg [7:0] din;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .din(din),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            addr = 5'h00; din = 8'h00;
            $display("Test %0d: All Zeros (addr=%h, din=%h)", test_num, addr, din);
            #1;

            check_outputs(expected_scramble(addr, din));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            addr = 5'h00; din = 8'hFF;
            $display("Test %0d: Max Data, Min Addr (addr=%h, din=%h)", test_num, addr, din);
            #1;

            check_outputs(expected_scramble(addr, din));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            addr = 5'h1F; din = 8'h00;
            $display("Test %0d: Min Data, Max Addr (addr=%h, din=%h)", test_num, addr, din);
            #1;

            check_outputs(expected_scramble(addr, din));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            addr = 5'h1F; din = 8'hFF;
            $display("Test %0d: All Ones (addr=%h, din=%h)", test_num, addr, din);
            #1;

            check_outputs(expected_scramble(addr, din));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            addr = 5'h0A; din = 8'h55;
            $display("Test %0d: Alternating Bits A (addr=%h, din=%h)", test_num, addr, din);
            #1;

            check_outputs(expected_scramble(addr, din));
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            addr = 5'h15; din = 8'hAA;
            $display("Test %0d: Alternating Bits B (addr=%h, din=%h)", test_num, addr, din);
            #1;

            check_outputs(expected_scramble(addr, din));
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            addr = 5'h01; din = 8'h01;
            $display("Test %0d: Low Bit Interaction (addr=%h, din=%h)", test_num, addr, din);
            #1;

            check_outputs(expected_scramble(addr, din));
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            addr = 5'h10; din = 8'h80;
            $display("Test %0d: High Bit Interaction (addr=%h, din=%h)", test_num, addr, din);
            #1;

            check_outputs(expected_scramble(addr, din));
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            addr = 5'h07; din = 8'hC3;
            $display("Test %0d: Arbitrary Pattern 1 (addr=%h, din=%h)", test_num, addr, din);
            #1;

            check_outputs(expected_scramble(addr, din));
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            addr = 5'h12; din = 8'h3C;
            $display("Test %0d: Arbitrary Pattern 2 (addr=%h, din=%h)", test_num, addr, din);
            #1;

            check_outputs(expected_scramble(addr, din));
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
        input [7:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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

endmodule
