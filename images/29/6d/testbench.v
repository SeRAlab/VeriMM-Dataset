`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data;
    reg re;
    reg reset;
    reg we;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .data(data),
        .re(re),
        .reset(reset),
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
            reset = 1;
            we = 0;
            data = 4'h0;
            #12;
            reset = 0;
            #8;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Asynchronous Reset Check", test_num);
            reset_dut();

            wait(re == 1);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Read (4'hA)", test_num);
            reset_dut();
            data = 4'hA;
            we = 1;
            #10;
            we = 0;
            wait(re == 1);
            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Read (4'h5)", test_num);
            reset_dut();
            data = 4'h5;
            we = 1;
            #10;
            we = 0;
            wait(re == 1);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write Enable (we) Low Check", test_num);
            reset_dut();
            data = 4'hF;
            we = 0;
            #10;
            wait(re == 1);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset after Write Check", test_num);
            reset_dut();
            data = 4'hC;
            we = 1;
            #10;
            we = 0;
            reset = 1;
            #5;
            reset = 0;
            wait(re == 1);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All-ones Write (4'hF)", test_num);
            reset_dut();
            data = 4'hF;
            we = 1;
            #10;
            we = 0;
            wait(re == 1);
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple Sequential Writes", test_num);
            reset_dut();

            data = 4'h1; we = 1; #10;
            data = 4'h2; we = 1; #10;
            data = 4'h3; we = 1; #10;

            we = 0;
            wait(re == 1);
            #1;
            #1;

            check_outputs(4'h3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        $dumpvars(0,data, re, reset, we, q);
    end

endmodule
