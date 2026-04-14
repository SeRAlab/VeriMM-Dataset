`timescale 1ns/1ps

module freq_div_tb;

    // Testbench signals (sequential circuit)
    reg CLK_in;
    reg RST;
    wire CLK_1;
    wire CLK_10;
    wire CLK_50;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    freq_div dut (
        .CLK_in(CLK_in),
        .RST(RST),
        .CLK_1(CLK_1),
        .CLK_10(CLK_10),
        .CLK_50(CLK_50)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_in = 0;
        forever #5 CLK_in = ~CLK_in;
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
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: CLK_50 toggle check (1 cycle)", test_num);
            reset_dut();
            @(posedge CLK_in);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: CLK_10 toggle check (5 cycles)", test_num);
            reset_dut();
            repeat(5) @(posedge CLK_in);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: CLK_10 full period check (10 cycles)", test_num);
            reset_dut();
            repeat(10) @(posedge CLK_in);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: CLK_1 toggle check (50 cycles)", test_num);
            reset_dut();
            repeat(50) @(posedge CLK_in);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: CLK_1 full period check (100 cycles)", test_num);
            reset_dut();
            repeat(100) @(posedge CLK_in);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Midpoint check (75 cycles)", test_num);
            reset_dut();
            repeat(75) @(posedge CLK_in);
            #1;



            #1;




            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("freq_div Testbench");
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
        input expected_CLK_1;
        input expected_CLK_10;
        input expected_CLK_50;
        begin
            if (expected_CLK_1 === (expected_CLK_1 ^ CLK_1 ^ expected_CLK_1) &&
                expected_CLK_10 === (expected_CLK_10 ^ CLK_10 ^ expected_CLK_10) &&
                expected_CLK_50 === (expected_CLK_50 ^ CLK_50 ^ expected_CLK_50)) begin
                $display("PASS");
                $display("  Outputs: CLK_1=%b, CLK_10=%b, CLK_50=%b",
                         CLK_1, CLK_10, CLK_50);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLK_1=%b, CLK_10=%b, CLK_50=%b",
                         expected_CLK_1, expected_CLK_10, expected_CLK_50);
                $display("  Got:      CLK_1=%b, CLK_10=%b, CLK_50=%b",
                         CLK_1, CLK_10, CLK_50);
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
        $dumpvars(0,CLK_in, RST, CLK_1, CLK_10, CLK_50);
    end

endmodule
