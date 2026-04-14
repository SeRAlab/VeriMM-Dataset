`timescale 1ns/1ps

module johnson_counter_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    johnson_counter dut (
        .CLK(CLK),
        .RST(RST),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            @(negedge CLK);
            RST = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge CLK);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            repeat(2) @(negedge CLK);
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            repeat(3) @(negedge CLK);
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            repeat(4) @(negedge CLK);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            repeat(5) @(negedge CLK);
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            repeat(6) @(negedge CLK);
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            repeat(7) @(negedge CLK);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            repeat(8) @(negedge CLK);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            repeat(9) @(negedge CLK);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("johnson_counter Testbench");
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,CLK, RST, Q);
    end

endmodule
