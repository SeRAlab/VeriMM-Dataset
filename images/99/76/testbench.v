`timescale 1ns/1ps

module bin_counter_4bit_up_down_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg MODE;
    reg RST;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bin_counter_4bit_up_down dut (
        .CLK(CLK),
        .MODE(MODE),
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
            MODE = 1;
            @(posedge CLK);
            #1;
            RST = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Up Counting (5 steps)", test_num);
            reset_dut();
            MODE = 1;
            repeat (5) @(posedge CLK);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Down Counting Wrap-around (0 to 15)", test_num);
            reset_dut();
            MODE = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Up Counting Full Cycle Wrap-around", test_num);
            reset_dut();
            MODE = 1;
            repeat (16) @(posedge CLK);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Switch Mode (Up 10 then Down 3)", test_num);
            reset_dut();
            MODE = 1;
            repeat (10) @(posedge CLK);
            MODE = 0;
            repeat (3) @(posedge CLK);
            #1;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset Priority over Mode", test_num);
            reset_dut();
            MODE = 1;
            repeat (4) @(posedge CLK);
            RST = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'h0);
            RST = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Continuous Down Counting (8 steps)", test_num);
            reset_dut();
            MODE = 0;
            repeat (8) @(posedge CLK);
            #1;
            #1;

            check_outputs(4'h8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bin_counter_4bit_up_down Testbench");
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
        $dumpvars(0,CLK, MODE, RST, Q);
    end

endmodule
