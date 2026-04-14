`timescale 1ns/1ps

module wait_state_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg nM1;
    reg nMREQ;
    wire nWAIT_M1;
    wire nWAIT_Mem;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wait_state dut (
        .CLK(CLK),
        .nM1(nM1),
        .nMREQ(nMREQ),
        .nWAIT_M1(nWAIT_M1),
        .nWAIT_Mem(nWAIT_Mem)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin

            nM1 = 1'b1;
            nMREQ = 1'b1;

            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: System Idle State", test_num);
            reset_dut();


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: M1 Wait Signal Activation", test_num);
            reset_dut();

            @(negedge CLK);
            nM1 = 1'b0;
            nMREQ = 1'b1;

            @(posedge CLK);
            #2;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Memory Request Wait Signal Activation", test_num);
            reset_dut();

            @(negedge CLK);
            nM1 = 1'b1;
            nMREQ = 1'b0;

            @(posedge CLK);
            #2;


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Concurrent M1 and Memory Request", test_num);
            reset_dut();

            @(negedge CLK);
            nM1 = 1'b0;
            nMREQ = 1'b0;

            @(posedge CLK);
            #2;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Recovery After Signal Release", test_num);
            reset_dut();


            @(negedge CLK);
            nM1 = 1'b0;
            nMREQ = 1'b0;
            @(posedge CLK);


            @(negedge CLK);
            nM1 = 1'b1;
            nMREQ = 1'b1;

            @(posedge CLK);
            #2;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wait_state Testbench");
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
        input expected_nWAIT_M1;
        input expected_nWAIT_Mem;
        begin
            if (expected_nWAIT_M1 === (expected_nWAIT_M1 ^ nWAIT_M1 ^ expected_nWAIT_M1) &&
                expected_nWAIT_Mem === (expected_nWAIT_Mem ^ nWAIT_Mem ^ expected_nWAIT_Mem)) begin
                $display("PASS");
                $display("  Outputs: nWAIT_M1=%b, nWAIT_Mem=%b",
                         nWAIT_M1, nWAIT_Mem);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nWAIT_M1=%b, nWAIT_Mem=%b",
                         expected_nWAIT_M1, expected_nWAIT_Mem);
                $display("  Got:      nWAIT_M1=%b, nWAIT_Mem=%b",
                         nWAIT_M1, nWAIT_Mem);
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
        $dumpvars(0,CLK, nM1, nMREQ, nWAIT_M1, nWAIT_Mem);
    end

endmodule
