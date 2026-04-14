`timescale 1ns/1ps

module counter_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg EN;
    reg RST;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter dut (
        .CLK(CLK),
        .EN(EN),
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
            EN = 0;
            #10;
            RST = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Simple Increment Check", test_num);
            reset_dut();
            EN = 1;
            repeat(5) @(posedge CLK);
            #2;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Enable/Disable Check", test_num);
            reset_dut();
            EN = 1;
            repeat(3) @(posedge CLK);
            EN = 0;
            repeat(5) @(posedge CLK);
            EN = 1;
            repeat(2) @(posedge CLK);
            #2;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Overflow/Wrap-around Check", test_num);
            reset_dut();
            EN = 1;
            repeat(256) @(posedge CLK);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Asynchronous Reset Mid-cycle Check", test_num);
            reset_dut();
            EN = 1;
            repeat(10) @(posedge CLK);
            #2;
            RST = 1;
            #1;
            #1;

            check_outputs(8'h00);
            RST = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Max Value Check", test_num);
            reset_dut();
            EN = 1;
            repeat(255) @(posedge CLK);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter Testbench");
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
        input [7:0] expected_Q;
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
        $dumpvars(0,CLK, EN, RST, Q);
    end

endmodule
