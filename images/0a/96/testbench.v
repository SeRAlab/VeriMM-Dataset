`timescale 1ns/1ps

module divide_by_8_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [2:0] quotient;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divide_by_8 dut (
        .clk(clk),
        .reset(reset),
        .quotient(quotient)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #2 reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset state check", test_num);
            reset_dut();
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Increment after 1 cycle", test_num);
            reset_dut();
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Value after 4 cycles", test_num);
            reset_dut();
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Value after 7 cycles (Max value)", test_num);
            reset_dut();
            repeat(7) @(posedge clk);
            #2;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Wrap-around after 8 cycles", test_num);
            reset_dut();
            repeat(8) @(posedge clk);
            #2;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple wrap-arounds (19 cycles)", test_num);
            reset_dut();
            repeat(19) @(posedge clk);
            #2;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-sequence reset", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #2;
            reset_dut();
            #1;

            check_outputs(3'b000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divide_by_8 Testbench");
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
        input [2:0] expected_quotient;
        begin
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h",
                         quotient);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h",
                         expected_quotient);
                $display("  Got:      quotient=%h",
                         quotient);
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
        $dumpvars(0,clk, reset, quotient);
    end

endmodule
