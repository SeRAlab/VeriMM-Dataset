`timescale 1ns/1ps

module clock_buffer_tb;

    // Testbench signals (sequential circuit)
    reg CLK_IN;
    reg RST;
    wire CLK_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_buffer dut (
        .CLK_IN(CLK_IN),
        .RST(RST),
        .CLK_OUT(CLK_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_IN = 0;
        forever #5 CLK_IN = ~CLK_IN;
    end

        task reset_dut;

        begin
            RST = 1;
            #20;
            RST = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: CLK_OUT is 0 when RST is high", test_num);

            RST = 1;
            #23;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: CLK_OUT follows CLK_IN (Logic High)", test_num);
            reset_dut();

            wait(CLK_IN === 1'b1);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: CLK_OUT follows CLK_IN (Logic Low)", test_num);
            reset_dut();

            wait(CLK_IN === 1'b0);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Immediate output update upon RST release (Async)", test_num);
            RST = 1;

            wait(CLK_IN === 1'b1);
            #1;
            RST = 0;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Immediate output clear upon RST assertion", test_num);
            reset_dut();
            wait(CLK_IN === 1'b1);
            #1;
            RST = 1;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("clock_buffer Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_CLK_OUT;
        begin
            if (expected_CLK_OUT === (expected_CLK_OUT ^ CLK_OUT ^ expected_CLK_OUT)) begin
                $display("PASS");
                $display("  Outputs: CLK_OUT=%b",
                         CLK_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLK_OUT=%b",
                         expected_CLK_OUT);
                $display("  Got:      CLK_OUT=%b",
                         CLK_OUT);
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
        $dumpvars(0,CLK_IN, RST, CLK_OUT);
    end

endmodule
