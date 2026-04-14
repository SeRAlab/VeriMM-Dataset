`timescale 1ns/1ps

module jk_flip_flop_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg j;
    reg k;
    reg rst;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jk_flip_flop dut (
        .clk(clk),
        .j(j),
        .k(k),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            rst = 1;
            j = 0;
            k = 0;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Asynchronous Reset", test_num);
            reset_dut();


            j = 1; k = 0;
            @(negedge clk);


            #2 rst = 1;
            #1;
            #1;

            check_outputs(1'b0);
            rst = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Set Operation (J=1, K=0)", test_num);
            reset_dut();

            j = 1;
            k = 0;
            @(negedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Reset Operation (J=0, K=1)", test_num);
            reset_dut();


            j = 1; k = 0;
            @(negedge clk);


            j = 0; k = 1;
            @(negedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Hold Operation (J=0, K=0) from High", test_num);
            reset_dut();


            j = 1; k = 0;
            @(negedge clk);


            j = 0; k = 0;
            @(negedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Hold Operation (J=0, K=0) from Low", test_num);
            reset_dut();


            j = 0; k = 0;
            @(negedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Toggle Operation (0 -> 1)", test_num);
            reset_dut();

            j = 1; k = 1;
            @(negedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Toggle Operation (1 -> 0)", test_num);
            reset_dut();


            j = 1; k = 0;
            @(negedge clk);


            j = 1; k = 1;
            @(negedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Multiple Toggles", test_num);
            reset_dut();

            j = 1; k = 1;
            @(negedge clk);
            @(negedge clk);
            @(negedge clk);

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
        $display("jk_flip_flop Testbench");
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
        input expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
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
        $dumpvars(0,clk, j, k, rst, q);
    end

endmodule
