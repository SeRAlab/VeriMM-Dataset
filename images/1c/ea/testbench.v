`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data;
    reg re;
    reg we;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .data(data),
        .re(re),
        .we(we),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        re = 0;
        forever #5 re = ~re;
    end

        task reset_dut;

        begin
            we = 0;
            data = 4'h0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Write 4'hA and Verify Read", test_num);

            we = 1;
            data = 4'hA;
            #10;
            we = 0;

            wait(re == 1);
            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Write 4'h5 and Verify Read", test_num);
            we = 1;
            data = 4'h5;
            #10;
            we = 0;
            wait(re == 1);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Sequential Writes, Verify Last Value", test_num);
            we = 1; data = 4'h1; #10;
            we = 1; data = 4'hF; #10;
            we = 0;
            wait(re == 1);
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Verify Hold logic (re=0, we=0)", test_num);

            we = 1; data = 4'hC; #10;
            we = 0;

            wait(re == 1); #2;

            wait(re == 0);
            #2;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Verify no write occurs when we is low", test_num);

            we = 1; data = 4'hB; #10;

            we = 0; data = 4'h2; #10;

            wait(re == 1);
            #1;
            #1;

            check_outputs(4'hB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,data, re, we, q);
    end

endmodule
