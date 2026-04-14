`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg RE;
    reg RESET;
    reg SET;
    reg WE;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .D(D),
        .RE(RE),
        .RESET(RESET),
        .SET(SET),
        .WE(WE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        RE = 0;
        forever #5 RE = ~RE;
    end

        task reset_dut;

    begin
        RESET = 1;
        SET = 0;
        WE = 0;
        D = 0;
        #20;
        RESET = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Reset Functionality", test_num);


        wait(RE == 1);
        #2;
        #1;

        check_outputs(1'b0);
        wait(RE == 0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Set Functionality", test_num);

        SET = 1;
        #10;
        SET = 0;
        #10;

        wait(RE == 1);
        #2;
        #1;

        check_outputs(1'b1);
        wait(RE == 0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Write '1' and Read", test_num);

        D = 1;
        WE = 1;
        #10;
        WE = 0;
        #10;

        wait(RE == 1);
        #2;
        #1;

        check_outputs(1'b1);
        wait(RE == 0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();

        SET = 1;
        #10;
        SET = 0;

        test_num = test_num + 1;
        $display("Test %0d: Write '0' and Read", test_num);

        D = 0;
        WE = 1;
        #10;
        WE = 0;
        #10;

        wait(RE == 1);
        #2;
        #1;

        check_outputs(1'b0);
        wait(RE == 0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();

        D = 1;
        WE = 1;
        #10;
        WE = 0;

        test_num = test_num + 1;
        $display("Test %0d: Data Persistence (WE=0)", test_num);


        D = 0;
        WE = 0;
        #20;

        wait(RE == 1);
        #2;
        #1;

        check_outputs(1'b1);
        wait(RE == 0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: SET Priority over Write", test_num);

        D = 0;
        WE = 1;
        SET = 1;
        #10;
        WE = 0;
        SET = 0;

        wait(RE == 1);
        #2;
        #1;

        check_outputs(1'b1);
        wait(RE == 0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();

        SET = 1;
        #10;
        SET = 0;

        test_num = test_num + 1;
        $display("Test %0d: RESET Priority over Write", test_num);

        D = 1;
        WE = 1;
        RESET = 1;
        #10;
        WE = 0;
        RESET = 0;

        wait(RE == 1);
        #2;
        #1;

        check_outputs(1'b0);
        wait(RE == 0);
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
        $dumpvars(0,D, RE, RESET, SET, WE, Q);
    end

endmodule
