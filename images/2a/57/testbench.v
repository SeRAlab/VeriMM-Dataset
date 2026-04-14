`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg WE;
    reg clk;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .D(D),
        .WE(WE),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            WE <= 1;
            D  <= 0;
            @(posedge clk);
            WE <= 0;
            D  <= 0;
            @(posedge clk);
            $display("DUT Reset (Stored 0)");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write 1 and Read", test_num);
            reset_dut();

            @(posedge clk);
            WE <= 1;
            D  <= 1;
            @(posedge clk);
            WE <= 0;
            D  <= 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write 0 and Read", test_num);

            @(posedge clk);
            WE <= 1;
            D  <= 1;
            @(posedge clk);


            WE <= 1;
            D  <= 0;
            @(posedge clk);
            WE <= 0;
            D  <= 1;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Hold (WE=0)", test_num);
            reset_dut();


            @(posedge clk);
            WE <= 1;
            D  <= 1;
            @(posedge clk);


            WE <= 0;
            D  <= 0;
            @(posedge clk);
            D  <= 1;
            @(posedge clk);
            D  <= 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Consecutive Writes (Toggle)", test_num);
            reset_dut();

            @(posedge clk);
            WE <= 1;
            D  <= 1;
            @(posedge clk);
            D  <= 0;
            @(posedge clk);
            D  <= 1;
            @(posedge clk);
            WE <= 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Long-term Read Stability", test_num);
            reset_dut();


            @(posedge clk);
            WE <= 1;
            D  <= 1;
            @(posedge clk);
            WE <= 0;


            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b1);
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
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
        $dumpvars(0,D, WE, clk, Q);
    end

endmodule
